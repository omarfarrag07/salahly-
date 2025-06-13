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
    
        $service = $provider->service()->first(); 
    
        if (!$service) {
            return response()->json(['error' => 'No service linked.'], 404);
        }
    
        $requests = $service->requests()
            ->with('user')
            ->get();
    
        return response()->json($requests);
}
public function getRequestByID($id)
{
    $provider = auth()->user();
    $service = $provider->service()->first();
    
    if (!$provider->isProvider()) {
        return response()->json(['error' => 'Unauthorized.'], 403);
    }

    if (!$service) {
        return response()->json(['error' => 'No service linked.'], 404);
    }

    $serviceRequest = $service->requests()
        ->with(['user', 'offers'])
        ->findOrFail($id);

    return response()->json($serviceRequest);
}
    


public function sendOffer(Request $request, $id)
{
    $provider = auth()->user();
    $service = $provider->service;
    if (!$provider->isProvider()) {
        return response()->json(['error' => 'Unauthorized.'], 403);
    }

    $request->validate([
        'price' => 'required|numeric|min:0',
        'message' => 'nullable|string|max:1000',
    ]);

   

    if (!$service) {
        return response()->json(['error' => 'No service linked.'], 404);
    }

    $serviceRequest = $service->requests()->findOrFail($id);

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
        'offer' => $offer,], 201);
}


}
