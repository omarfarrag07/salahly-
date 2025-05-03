<?php

namespace App\Http\Controllers;

use App\Models\AcceptedOffer;
use App\Models\Offer;
use App\Models\ServiceRequest;
use Illuminate\Http\Request;
use App\Events\ChatStarted;

class OfferController extends Controller
{
    public function index()
    {
        // List all offers for the authenticated provider
        $offers = auth()->user()->offers()->with('serviceRequest')->latest()->paginate(10);
        return response()->json($offers);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'service_request_id' => 'required|exists:service_requests,id',
            'price' => 'required|numeric|min:0',
            'notes' => 'nullable|string|max:500'
        ]);

        $serviceRequest = ServiceRequest::findOrFail($validated['service_request_id']);

        if ($serviceRequest->status !== 'pending') {
            return response()->json(['message' => 'You can only offer on pending requests'], 400);
        }

        $offer = auth()->user()->offers()->create([
            ...$validated,
            'status' => 'sent'
        ]);

        return response()->json($offer, 201);
    }

    public function show($id)
    {
        $offer = Offer::with(['provider', 'serviceRequest'])->findOrFail($id);
        return response()->json($offer);
    }

    public function accept($id)
    {
        $offer = Offer::findOrFail($id);

        if ($offer->serviceRequest->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if (AcceptedOffer::where('service_request_id', $offer->service_request_id)->exists()) {
            return response()->json(['message' => 'Request already accepted'], 400);
        }

        $offer->serviceRequest->update(['status' => 'accepted']);

        $acceptedOffer = AcceptedOffer::create([
            'offer_id' => $offer->id,
            'service_request_id' => $offer->service_request_id
        ]);

        event(new ChatStarted([
            'chat_id' => $acceptedOffer->id,
            'user_id' => $offer->serviceRequest->user_id,
            'provider_id' => $offer->provider_id,
            'service_request_id' => $offer->service_request_id
        ]));

        return response()->json([
            'message' => 'Offer accepted and chat started.',
            'accepted_offer' => $acceptedOffer
        ], 201);
    }


    public function reject($id)
    {
        $offer = Offer::findOrFail($id);

        if ($offer->serviceRequest->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $offer->update(['status' => 'rejected']);
        return response()->json($offer);
    }
}
