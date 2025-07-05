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
    
        $request->validate([
            'amount' => 'required|numeric|min:1',
            'gateway' => 'required|string|in:paypal,stripe,cash,credit',
            'service_request_id' => 'required|exists:service_requests,id',
        ]);
    
        $serviceRequest = ServiceRequest::with('user')->findOrFail($request->service_request_id);
    
        if ($serviceRequest->user_id !== $user->id) {
            return response()->json(['message' => 'You can only pay for your own service requests.'], 403);
        }
    
        if (Payment::where('service_request_id', $request->service_request_id)->exists()) {
            return response()->json(['message' => 'Payment already made for this request'], 409);
        }
    
        $acceptedOffer = AcceptedOffer::where('service_request_id', $request->service_request_id)->first();
    
        if (!$acceptedOffer) {
            return response()->json(['message' => 'No accepted offer found for this request.'], 403);
        }
    
        if ($serviceRequest->status !== 'completed') {
            return response()->json(['message' => 'You can only pay after the service is completed.'], 403);
        }
    
        $providerId = $acceptedOffer->provider_id;
    
        $strategy = match ($request->gateway) {
            'paypal' => new PayPalPayment(),
            'stripe' => new StripePayment(),
            'credit' => new CreditPayment(),
            default => new CashPayment(),
        };
    
        try {
            $payment = $strategy->pay([
                'user_id' => $user->id,
                'amount' => $request->amount,
                'provider_id' => $providerId,
                'service_request_id' => $request->service_request_id,
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'payment error'], 400);
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
