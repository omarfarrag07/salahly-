<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProviderController extends Controller
{
    public function index()
    {
        $providers = User::where('type', 'Provider')->with(['offers', 'ratings'])->get();
        return response()->json($providers);
    }

    public function show($id)
    {
        $provider = User::where('type', 'Provider')->with(['offers', 'ratings'])->findOrFail($id);
        return response()->json($provider);
    }

    public function update(Request $request, $id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
        $provider->update($request->only('name', 'email', 'phone'));
        return response()->json($provider);
    }

    public function destroy($id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
        $provider->delete();
        return response()->json(['message' => 'Provider deleted']);
    }


    public function getAllRequests()
    {
        $provider = auth()->user();

        if (!$provider->isProvider()) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $serviceId = $provider->service_id; // service_id should be in the users table

        if (!$serviceId) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Fetch requests with the provider's service_id
        $requests = \App\Models\ServiceRequest::with('user')
            ->where('service_id', $serviceId)
            ->get();

        // If none found, fallback to "others" service (assuming you have a service named 'others')
        if ($requests->isEmpty()) {
            $othersService = \App\Models\Service::where('name', 'others')->first();
            if ($othersService) {
                $requests = \App\Models\ServiceRequest::with('user')
                    ->where('service_id', $othersService->id)
                    ->get();
            }
        }

        return response()->json($requests);
    }
    public function getRequestByID($id)
    {
        $provider = auth()->user();

        if (!$provider->isProvider()) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $serviceId = $provider->service_id; // Use service_id directly

        if (!$serviceId) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Find the service request by id and service_id
        $serviceRequest = \App\Models\ServiceRequest::with(['user', 'offers'])
            ->where('service_id', $serviceId)
            ->findOrFail($id);

        return response()->json($serviceRequest);
    }

    public function sendOffer(Request $request, $id)
    {
        $provider = auth()->user();
        $serviceId = $provider->service_id;

        if (!$provider->isProvider()) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $request->validate([
            'price' => 'required|numeric|min:0',
            'message' => 'nullable|string|max:1000',
        ]);

        if (!$serviceId) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Try to find the service request with the provider's service_id
        $serviceRequest = \App\Models\ServiceRequest::with('service')
            ->where('service_id', $serviceId)
            ->find($id);

        // Fallback to "others" if not found
        if (!$serviceRequest) {
            $othersService = \App\Models\Service::where('name', 'others')->first();
            if ($othersService) {
                $serviceRequest = \App\Models\ServiceRequest::with('service')
                    ->where('service_id', $othersService->id)
                    ->find($id);
            }
        }

        if (!$serviceRequest) {
            return response()->json(['error' => 'Service request not found for your service.'], 404);
        }

        if ($serviceRequest->status !== 'pending') {
            return response()->json(['error' => 'You can only offer on pending requests.'], 400);
        }

        if ($serviceRequest->offers()->where('provider_id', $provider->id)->exists()) {
            return response()->json(['error' => 'You already made an offer.'], 409);
        }

        $offer = $serviceRequest->offers()->create([
            'provider_id' => $provider->id,
            'price' => $request->price,
            'message' => $request->message,
        ]);

        return response()->json([
            'message' => 'Offer Sent Successfully!',
            'offer' => $offer,
        ], 201);
    }
}
