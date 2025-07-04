<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;

class LocationController extends Controller
{
    public function getNearbyProviders(Request $request)
    {
        $request->validate([
            'lat' => 'required|numeric',
            'lng' => 'required|numeric',
            'radius' => 'nullable|numeric', // radius in km, default to 5km
            'service_id' => 'nullable|integer',
        ]);

        $lat = $request->lat;
        $lng = $request->lng;
        $radius = $request->radius ?? 5;

        $query = User::selectRaw("*, (
                6371 * acos(
                    cos(radians(?)) * cos(radians(lat)) *
                    cos(radians(lng) - radians(?)) +
                    sin(radians(?)) * sin(radians(lat))
                )
            ) AS distance", [$lat, $lng, $lat])
            ->where('type', 'Provider')
            ->where('status', 'approved');

        if ($request->filled('service_id')) {
            $query->where('service_id', $request->service_id);
        }

        $providers = $query
            ->whereRaw("(
                6371 * acos(
                    cos(radians(?)) * cos(radians(lat)) *
                    cos(radians(lng) - radians(?)) +
                    sin(radians(?)) * sin(radians(lat))
                )
            ) < ?", [$lat, $lng, $lat, $radius])
            ->orderBy("distance")
            ->get();

        return response()->json($providers);
    }



    public function nearestProvider($id)
    {
        $serviceRequest = \App\Models\ServiceRequest::findOrFail($id);

        // Ensure the request has location and service
        if (!$serviceRequest->lat || !$serviceRequest->lng) {
            return response()->json(['message' => 'Service request does not have a location'], 400);
        }

        // Find nearest provider with the same service_id and approved status
        $nearestProvider = User::selectRaw("*, (
            6371 * acos(
                cos(radians(?)) * cos(radians(lat)) *
                cos(radians(lng) - radians(?)) +
                sin(radians(?)) * sin(radians(lat))
            )
        ) AS distance", [
            $serviceRequest->lat,
            $serviceRequest->lng,
            $serviceRequest->lat
        ])
            ->where('type', 'Provider')
            ->where('status', 'approved')
            ->where('service_id', $serviceRequest->service_id)
            ->orderBy('distance')
            ->first();

        if (!$nearestProvider) {
            return response()->json(['message' => 'No provider found'], 404);
        }

        return response()->json($nearestProvider);
    }



    public function nearestProvidersToServiceRequest($id)
    {
        $serviceRequest = \App\Models\ServiceRequest::findOrFail($id);

        // Ensure the request has location and service
        if (!$serviceRequest->lat || !$serviceRequest->lng) {
            return response()->json(['message' => 'Service request does not have a location'], 400);
        }

        // Find providers ordered by distance with the same service_id and approved status
        $providers = User::selectRaw("*, (
        6371 * acos(
            cos(radians(?)) * cos(radians(lat)) *
            cos(radians(lng) - radians(?)) +
            sin(radians(?)) * sin(radians(lat))
        )
    ) AS distance", [
            $serviceRequest->lat,
            $serviceRequest->lng,
            $serviceRequest->lat
        ])
            ->where('type', 'Provider')
            ->where('status', 'approved')
            ->where('service_id', $serviceRequest->service_id)
            ->orderBy('distance')
            // ->limit(10) // optional: limit to top 10 nearest providers
            ->get();

        if ($providers->isEmpty()) {
            return response()->json(['message' => 'No providers found'], 404);
        }

        return response()->json($providers);
    }
}
