<?php

namespace App\Services;

use App\Models\ServiceRequest;
use App\Models\User;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;

/**
 * LocationService - Handles provider discovery and location-based queries
 */
class LocationService
{
    protected DistanceService $distanceService;

    public function __construct(DistanceService $distanceService)
    {
        $this->distanceService = $distanceService;
    }

    /**
     * Get nearby providers within a given radius and optional service filter
     * 
     * @param float $lat User latitude
     * @param float $lng User longitude
     * @param float $radius Search radius in kilometers (default: 5km)
     * @param int|null $serviceId Optional service filter
     * @return Collection Providers ordered by distance
     * @throws \InvalidArgumentException If coordinates are invalid
     */
    public function getNearbyProviders(float $lat, float $lng, float $radius = 5, ?int $serviceId = null): Collection
    {
        if (!$this->distanceService->isValidCoordinates($lat, $lng)) {
            throw new \InvalidArgumentException('Invalid coordinates provided');
        }

        [$haversineSql, $params] = $this->distanceService->getHaversineSQL($lat, $lng);

        $query = User::selectRaw("*, ({$haversineSql}) AS distance", $params)
            ->where('type', 'Provider')
            ->where('status', 'approved');

        if ($serviceId !== null) {
            $query->where('service_id', $serviceId);
        }

        $providers = $query
            ->whereRaw("({$haversineSql}) < ?", array_merge($params, [$radius]))
            ->orderBy('distance')
            ->get();

        return $providers;
    }

    /**
     * Get the nearest provider to a service request
     * 
     * @param int $serviceRequestId
     * @return User|null The nearest provider or null if not found
     * @throws \Exception If service request not found or has invalid location
     */
    public function getNearestProvider(int $serviceRequestId): ?User
    {
        $serviceRequest = ServiceRequest::findOrFail($serviceRequestId);

        if (!$serviceRequest->lat || !$serviceRequest->lng) {
            throw new \Exception('Service request does not have a location');
        }

        if (!$serviceRequest->service_id) {
            throw new \Exception('Service request does not have a service assigned');
        }

        [$haversineSql, $params] = $this->distanceService->getHaversineSQL($serviceRequest->lat, $serviceRequest->lng);

        $nearestProvider = User::selectRaw("*, ({$haversineSql}) AS distance", $params)
            ->where('type', 'Provider')
            ->where('status', 'approved')
            ->where('service_id', $serviceRequest->service_id)
            ->orderBy('distance')
            ->first();

        return $nearestProvider;
    }

    /**
     * Get all providers near a service request, ordered by distance
     * 
     * @param int $serviceRequestId
     * @param int|null $limit Maximum number of providers to return
     * @return Collection Providers ordered by distance
     * @throws \Exception If service request not found or has invalid location
     */
    public function getNearestProvidersToServiceRequest(int $serviceRequestId, ?int $limit = null): Collection
    {
        $serviceRequest = ServiceRequest::findOrFail($serviceRequestId);

        if (!$serviceRequest->lat || !$serviceRequest->lng) {
            throw new \Exception('Service request does not have a location');
        }

        if (!$serviceRequest->service_id) {
            throw new \Exception('Service request does not have a service assigned');
        }

        [$haversineSql, $params] = $this->distanceService->getHaversineSQL($serviceRequest->lat, $serviceRequest->lng);

        $query = User::selectRaw("*, ({$haversineSql}) AS distance", $params)
            ->where('type', 'Provider')
            ->where('status', 'approved')
            ->where('service_id', $serviceRequest->service_id)
            ->orderBy('distance');

        if ($limit !== null) {
            $query->limit($limit);
        }

        return $query->get();
    }
}
