<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\AcceptedOffer;

class AcceptedOfferController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $acceptedOffers = AcceptedOffer::with(['offer.provider', 'request.user'])->paginate(10);
        return response()->json($acceptedOffers);
    }

    public function showByRequest($requestId)
    {
        $accepted = AcceptedOffer::with(['offer.provider', 'request.user'])
            ->where('service_request_id', $requestId)
            ->first();

        if (!$accepted) {
            return response()->json(['message' => 'Not accepted yet'], 404);
        }

        return response()->json($accepted);
    }

    public function acceptedOfferforUser($userId)
    {
        $acceptedOffers = AcceptedOffer::with(['offer.provider', 'request.user'])
            ->whereHas('serviceRequest', function ($query) use ($userId) {
                $query->where('user_id', $userId);
            })
            ->paginate(10);

        return response()->json($acceptedOffers);
    }

    /**
     * Show the form for creating a new resource.
     */
   
    /**
     * Store a newly created resource in storage.
     * (Usually not used directly; accepted offers are created when a user accepts an offer)
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'offer_id' => 'required|exists:offers,id',
            'service_request_id' => 'required|exists:service_requests,id',
        ]);

        $acceptedOffer = AcceptedOffer::create($validated);

        return response()->json($acceptedOffer, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $acceptedOffer = AcceptedOffer::with(['offer.provider', 'request.user'])->find($id);

        if (!$acceptedOffer) {
            return response()->json(['message' => 'Not found'], 404);
        }

        return response()->json($acceptedOffer);
    }

    /**
     * Update the specified resource in storage.
     * (Usually not needed, but you can allow updating status or notes)
     */
    public function update(Request $request, string $id)
    {
        $acceptedOffer = AcceptedOffer::find($id);

        if (!$acceptedOffer) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $validated = $request->validate([
            'status' => 'sometimes|string',
            // Add other updatable fields here
        ]);

        $acceptedOffer->update($validated);

        return response()->json($acceptedOffer);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $acceptedOffer = AcceptedOffer::find($id);

        if (!$acceptedOffer) {
            return response()->json(['message' => 'Not found'], 404);
        }

        $acceptedOffer->delete();

        return response()->json(['message' => 'Deleted successfully']);
    }
}
