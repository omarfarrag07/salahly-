<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Notifications\NewOfferNotification;
use App\Events\MyEvent; // Add this at the top

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

        $data = $request->except(['email', 'password', 'name', 'phone']);

        // Handle file uploads if present
        if ($request->hasFile('police_certificate')) {
            $data['police_certificate_path'] = $request->file('police_certificate')->store('certificates', 'public');
        }
        if ($request->hasFile('selfie')) {
            $data['selfie_path'] = $request->file('selfie')->store('selfies', 'public');
        }

        $provider->update($data);

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

        if ($provider->status !== 'approved') {
            return response()->json(['error' => 'Provider is inactive.'], 403);
        }

        $serviceId = $provider->service_id;

        if (!$serviceId) {
            return response()->json(['error' => 'No service linked.'], 404);
        }

        $requests = \App\Models\ServiceRequest::with([
            'user',
            'service',
            'offers' => function ($query) use ($provider) {
                $query->where('provider_id', $provider->id);
            }
        ])
            ->where('service_id', $serviceId)
            ->get();

        // Fallback to "others" service if no requests found
        if ($requests->isEmpty()) {
            $othersService = \App\Models\Service::where('name', 'others')->first();
            if ($othersService) {
                $requests = \App\Models\ServiceRequest::with([
                    'user',
                    'service',
                    'offers' => function ($query) use ($provider) {
                        $query->where('provider_id', $provider->id);
                    }
                ])
                    ->where('service_id', $othersService->id)
                    ->get();
            }
        }

        $requests->transform(function ($request) {
            $request->has_offered = $request->offers->isNotEmpty();
            unset($request->offers);
            return $request;
        });

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

        // Broadcast the event via Pusher
        $user_id = $serviceRequest->user->id;
        event(new MyEvent('Offer Sent Successfully!', $user_id));

        // Optionally notify the user as before
        // $user = User::find($request->user_id);
        // $user->notify(new NewOfferNotification($offer));

        return response()->json([
            'message' => 'Offer Sent Successfully!',
            'offer' => $offer,
        ], 201);
    }

    public function updateSelf(Request $request)
    {
        $provider = auth()->user();

        if (!$provider || $provider->type !== 'Provider') {
            return response()->json(['error' => 'Unauthorized.'], 403);
        }

        $data = [];

        // Define allowed fields to update
        $allowedFields = ['address', 'lat', 'lng', 'service_id', 'national_id'];

        foreach ($allowedFields as $field) {
            if ($request->has($field)) { // Use has() instead of filled()
                $data[$field] = $request->$field;
            }
        }

        // Handle file uploads if present
        if ($request->hasFile('police_certificate')) {
            $data['police_certificate_path'] = $request->file('police_certificate')->store('certificates', 'public');
        }
        if ($request->hasFile('selfie')) {
            $data['selfie_path'] = $request->file('selfie')->store('selfies', 'public');
        }

        if (empty($data)) {
            return response()->json(['message' => 'No valid fields to update.'], 400);
        }

        $provider->update($data);

        return response()->json($provider);
    }

}
