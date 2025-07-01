<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Payment;
use App\Models\ServiceRequest;
use App\Models\User;
use App\Payment\DummyPayment;
use App\Payment\CashPayment;
use App\Payment\PayPalPayment;
use App\Payment\StripePayment;

class PaymentController extends Controller
{
    
     // List all payments (admin or user history)
     
    public function index()
    {
        return response()->json(
            Payment::with(['user', 'provider', 'serviceRequest'])->get()
        );
    }

    //pay and update service request status
   
    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1',
            'gateway' => 'required|string|in:dummy,paypal,stripe,cash',
            'provider_id' => 'required|exists:users,id',
            'user_id' => 'required|exists:users,id',
            'service_request_id' => 'required|exists:service_requests,id',
        ]);

        $serviceRequest = ServiceRequest::findOrFail($request->service_request_id);

        if (Payment::where('service_request_id', $request->service_request_id)->exists()) {
            return response()->json(['message' => 'Payment already made for this request'], 409);
        }

        $strategy = match ($request->gateway) {
            'paypal' => new PayPalPayment(),
            'stripe' => new StripePayment(),
            'cash' => new CashPayment(),
            default => new DummyPayment(),
        };

        $payment = $strategy->pay([
            'user_id' => $request->user_id,
            'amount' => $request->amount,
            'provider_id' => $request->provider_id,
            'service_request_id' => $request->service_request_id,
        ]);

        $serviceRequest->status = 'paid';
        $serviceRequest->save();

        return response()->json([
            'message' => 'Payment processed successfully.',
            'payment' => $payment,
        ], 201);
    }

    
     //Show one payment
    public function show($id)
    {
        $payment = Payment::with(['user', 'provider', 'serviceRequest'])->findOrFail($id);

        return response()->json($payment);
    }

     // Delete a payment (admin or cleanup use)
    public function destroy($id)
    {
        $payment = Payment::findOrFail($id);
        $payment->delete();

        return response()->json(['message' => 'Payment deleted successfully']);
    }

     // Optional success redirect endpoint
    public function success()
    {
        return response()->json(['message' => 'Payment succeeded']);
    }

    
     // Optional cancel redirect endpoint
    public function cancel()
    {
        return response()->json(['message' => 'Payment cancelled']);
    }
}
