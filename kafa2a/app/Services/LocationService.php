<?php

namespace App\Services;

use App\Models\ServiceRequest;
use App\Models\User;
use Illuminate\Database\Eloquent\Collection;
use InvalidArgumentException;

/**
 * LocationService - Provider discovery and location-based matching
 *
 * PRIMARY FLOW (Core responsibility):
 * - getNearestProviders(ServiceRequest) — main method for matching providers to requests
 * - getNearestProvider(ServiceRequest) — convenience wrapper
 *
 * SECONDARY FLOWS (Utility for external searches):
 * - getNearbyProviders(lat, lng, radius) — for guest/coordinate-based searches
 *
 * All queries use providerDistanceQuery() for consistency and DRY.
 * Service layer does NOT fetch models (controller responsibility).
 * Service layer ONLY validates state and computes provider matches.
 */
class LocationService
{
    private const DEFAULT_PROVIDER_LIMIT = 10;

    protected DistanceService $distanceService;

    public function __construct(DistanceService $distanceService)
    {
        $this->distanceService = $distanceService;
    }

    // ===== PRIMARY FLOW: ServiceRequest-based provider matching =====

    /**
     * PRIMARY METHOD: Get nearest providers to a service request
     *
     * Core flow for matching providers to service requests.
     * Validates request state and returns distance-ordered collection.
     *
     * @param ServiceRequest $request Must have valid location and service_id
     * @param int $limit Maximum providers to return (default: 10)
     * @return Collection Approved providers ordered by distance
     *
     * @throws InvalidArgumentException If request is not ready for matching
     */
    public function getNearestProviders(ServiceRequest $request, int $limit = self::DEFAULT_PROVIDER_LIMIT): Collection
    {
        $request->ensureReadyForMatching();

        return $this->providerDistanceQuery($request->lat, $request->lng, $request->service_id)
            ->orderBy('distance')
            ->limit($limit)
            ->get();
    }

    /**
     * PRIMARY CONVENIENCE: Get single nearest provider to a service request
     *
     * Delegates to getNearestProviders() with limit 1.
     * Use this when you need exactly one provider.
     *
     * @throws InvalidArgumentException If request is not ready for matching
     */
    public function getNearestProvider(ServiceRequest $request): ?User
    {
        return $this->getNearestProviders($request, limit: 1)->first();
    }

    // ===== SECONDARY FLOW: Utility for raw coordinate searches =====

    /**
     * SECONDARY METHOD: Find providers by raw coordinates (for guest searches)
     *
     * Use case: External/guest searches that don't have a ServiceRequest.
     * NOT part of core provider-matching flow—only for external lookups.
     * Prefer getNearestProviders(ServiceRequest) for authenticated request-based flow.
     *
     * Applies distance radius filter (unlike getNearestProviders which returns N closest).
     * Reuses providerDistanceQuery() for consistency.
     *
     * @param float $lat Latitude coordinate
     * @param float $lng Longitude coordinate
     * @param float $radius Search radius in kilometers (default: 5km)
     * @param ?int $serviceId Optional service type filter
     * @param int $limit Maximum results to return (default: 10)
     * @return Collection Providers within radius, ordered by distance
     *
     * @throws InvalidArgumentException If coordinates are invalid
     */
    public function getNearbyProviders(
        float $lat,
        float $lng,
        float $radius = 5.0,
        ?int $serviceId = null,
        int $limit = self::DEFAULT_PROVIDER_LIMIT
    ): Collection {
        if (!$this->distanceService->isValidCoordinates($lat, $lng)) {
            throw new InvalidArgumentException('Invalid coordinates provided.');
        }

        [$haversineSql, $params] = $this->distanceService->getHaversineSQL($lat, $lng);

        // Reuse query builder, apply radius filter before limiting
        return $this->providerDistanceQuery($lat, $lng, $serviceId)
            ->whereRaw("({$haversineSql}) < ?", array_merge($params, [$radius]))
            ->orderBy('distance')
            ->limit($limit)
            ->get();
    }

    // ===== PRIVATE HELPERS: Single source of truth =====

    /**
     * PRIVATE: Build reusable provider distance query
     *
     * SINGLE SOURCE OF TRUTH for all provider queries.
     * Ensures consistent filtering and distance calculation across all methods.
     *
     * Includes:
     * - Haversine distance calculation from coordinates
     * - Filters: type=Provider, status=approved, optional service_id
     * - Distance computed column for ordering/filtering
     *
     * @param float $lat Latitude
     * @param float $lng Longitude
     * @param ?int $serviceId Optional service filter
     * @return \Illuminate\Database\Eloquent\Builder Query builder with distance column selectRaw
     */
    private function providerDistanceQuery(float $lat, float $lng, ?int $serviceId = null)
    {
        [$haversineSql, $params] = $this->distanceService->getHaversineSQL($lat, $lng);

        $query = User::selectRaw("*, ({$haversineSql}) AS distance", $params)
            ->where('type', 'Provider')
            ->where('status', 'approved');

        if ($serviceId !== null) {
            $query->where('service_id', $serviceId);
        }

        return $query;
    }
}
