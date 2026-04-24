<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\LocationService;

class LocationController extends Controller
{
    protected LocationService $locationService;

    public function __construct(LocationService $locationService)
    {
        $this->locationService = $locationService;
    }

    /**
     * Get nearby providers within a given radius
     */
    public function getNearbyProviders(Request $request)
    {
        $request->validate([
            'lat' => 'required|numeric|between:-90,90',
            'lng' => 'required|numeric|between:-180,180',
            'radius' => 'nullable|numeric|min:0.1', // radius in km, default to 5km
            'service_id' => 'nullable|integer|exists:services,id',
        ]);

        try {
            $providers = $this->locationService->getNearbyProviders(
                $request->lat,
                $request->lng,
                $request->radius ?? 5,
                $request->service_id
            );

            return response()->json($providers);
        } catch (\InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    /**
     * Get the nearest provider to a service request
     */
    public function nearestProvider($id)
    {
        try {
            $nearestProvider = $this->locationService->getNearestProvider($id);

            if (!$nearestProvider) {
                return response()->json(['message' => 'No provider found'], 404);
            }

            return response()->json($nearestProvider);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    /**
     * Get all providers near a service request, ordered by distance
     */
    public function nearestProvidersToServiceRequest($id)
    {
        try {
            $providers = $this->locationService->getNearestProvidersToServiceRequest($id);

            if ($providers->isEmpty()) {
                return response()->json(['message' => 'No providers found'], 404);
            }

            return response()->json($providers);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }
}
