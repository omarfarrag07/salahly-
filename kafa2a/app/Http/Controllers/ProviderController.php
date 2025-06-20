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

        $serviceName = $provider->service; // service is just a string

        if (!$serviceName) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Try to fetch requests with the provider's service name
        $requests = \App\Models\ServiceRequest::with('user')
            ->whereHas('service', function ($query) use ($serviceName) {
                $query->where('name', $serviceName);
            })
            ->get();

        // If none found, fallback to "others"
        if ($requests->isEmpty()) {
            $requests = \App\Models\ServiceRequest::with('user')
                ->whereHas('service', function ($query) {
                    $query->where('name', 'others');
                })
                ->get();
        }

        return response()->json($requests);
    }
    public function getRequestByID($id)
    {
        $provider = auth()->user();

        if (!$provider->isProvider()) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $serviceName = $provider->service; // service is just a string

        if (!$serviceName) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Find the service by name
        $service = \App\Models\Service::where('name', $serviceName)->first();

        if (!$service) {
            return response()->json(['error' => 'Service not found.'], 404);
        }

        // Find the service request by id and service_id
        $serviceRequest = \App\Models\ServiceRequest::with(['user', 'offers'])
            ->where('service_id', $service->id)
            ->findOrFail($id);

        return response()->json($serviceRequest);
    }



    public function sendOffer(Request $request, $id)
    {
        $provider = auth()->user();
        $serviceName = $provider->service;

        if (!$provider->isProvider()) {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $request->validate([
            'price' => 'required|numeric|min:0',
            'message' => 'nullable|string|max:1000',
        ]);

        if (!$serviceName) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        // Try to find the service request with the provider's service name
        $serviceRequest = \App\Models\ServiceRequest::with('service')
            ->whereHas('service', function ($query) use ($serviceName) {
                $query->where('name', $serviceName);
            })
            ->find($id);

        // Fallback to "others" if not found
        if (!$serviceRequest) {
            $serviceRequest = \App\Models\ServiceRequest::with('service')
                ->whereHas('service', function ($query) {
                    $query->where('name', 'others');
                })
                ->find($id);
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
