<?php

namespace App\Http\Controllers;

use App\Models\Offer;
use App\Models\ServiceRequest;
use Illuminate\Http\Request;

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

        $offer->update(['status' => 'accepted']);
        $offer->serviceRequest->update(['status' => 'accepted']);

        return response()->json($offer);
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
