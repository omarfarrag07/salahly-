<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Payment;
use App\Models\ServiceRequest;
use App\Models\User;
use App\Payment\CashPayment;
use App\Payment\PayPalPayment;
use App\Payment\StripePayment;
use App\Models\AcceptedOffer;


class PaymentController extends Controller
{

    // List all payments (admin or user history)

    public function index()
    {
        return response()->json(
            Payment::with(['user', 'provider', 'serviceRequest'])->get()
        );
    }

    public function store(Request $request)
    {
        $user = auth()->user();

        if (!$user || !$user->isUser()) {
            return response()->json(['message' => 'Unauthorized. Only users can perform this action.'], 403);
        }

        $validated = $request->validate([
            'amount' => 'required|numeric|min:1',
            'gateway' => 'required|string|in:paypal,stripe,cash,credit',
            'service_request_id' => 'required|exists:service_requests,id',
            'offer_id' => 'nullable|exists:offers,id', // Ensure offer_id is provided
        ]);

        $serviceRequest = ServiceRequest::with('user')->findOrFail($validated['service_request_id']);

        if ($serviceRequest->user_id !== $user->id) {
            return response()->json(['message' => 'You can only pay for your own service requests.'], 403);
        }

        if (Payment::where('service_request_id', $validated['service_request_id'])->exists()) {
            return response()->json(['message' => 'Payment already made for this request'], 409);
        }

        if ($serviceRequest->status !== 'completed') {
            return response()->json(['message' => 'You can only pay after the service is completed.'], 403);
        }

        $offer = AcceptedOffer::where('offer_id', $validated['offer_id']);
        if (!$offer) {
            return response()->json(['message' => 'No offer found for this service request.'], 404);
        }

        $providerId = $offer->provider_id;

        $strategy = match ($validated['gateway']) {
            'paypal' => new PayPalPayment(),
            'stripe' => new StripePayment(),
            'credit' => new CreditPayment(),
            default => new CashPayment(),
        };

        try {
            $payment = $strategy->pay([
                'user_id' => $user->id,
                'amount' => $validated['amount'],
                'service_request_id' => $validated['service_request_id'],
                'provider_id' => $providerId,
                'offer_id' => $validated['offer_id'] ?? null,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Payment error',
                'error' => $e->getMessage(),
            ], 400);
        }

        $serviceRequest->status = 'paid';
        $serviceRequest->save();

        return response()->json([
            'message' => 'Payment processed successfully.',
            'payment' => $payment,
        ], 201);
    }



    public function success()
    {
        return response()->json(['message' => 'Payment succeeded']);
    }


    public function cancel()
    {
        return response()->json(['message' => 'Payment cancelled']);
    }
}
