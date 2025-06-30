<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Payment;
use App\Models\ServiceRequest;
use App\Services\PaymentService;
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
            'service_request_id' => 'required|exists:service_requests,id',
        ]);

        // Select strategy based on payment method
        $strategy = match ($request->gateway) {
            'paypal' => new PayPalPayment(),   // to be implemented
            'stripe' => new StripePayment(),   // to be implemented
            'cash' => new CashPayment(),
            default => new DummyPayment(),
        };

        // Process payment
        $paymentService = new PaymentService($strategy);
        $payment = $paymentService->pay([
            'amount' => $request->amount,
            'provider_id' => $request->provider_id,
            'service_request_id' => $request->service_request_id,
        ]);

        // Update related service request status to 'paid'
        $serviceRequest = ServiceRequest::find($request->service_request_id);
        if ($serviceRequest) {
            $serviceRequest->status = 'paid';
            $serviceRequest->save();
        }

        return response()->json([
            'message' => 'Payment processed successfully and service marked as paid.',
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
