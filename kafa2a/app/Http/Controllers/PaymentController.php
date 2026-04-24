<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\PaymentService;

class PaymentController extends Controller
{
    protected PaymentService $paymentService;

    public function __construct(PaymentService $paymentService)
    {
        $this->paymentService = $paymentService;
    }

    /**
     * List all payments (admin or user history)
     */
    public function index()
    {
        $payments = $this->paymentService->getAllPayments();
        return response()->json($payments);
    }

    /**
     * Process payment for a completed service request
     */
    public function store(Request $request)
    {
        $user = auth()->user();

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $validated = $request->validate([
            'amount' => 'required|numeric|min:1',
            'gateway' => 'required|string|in:paypal,stripe,cash,credit',
            'service_request_id' => 'required|exists:service_requests,id',
            'offer_id' => 'nullable|exists:offers,id',
        ]);

        try {
            $payment = $this->paymentService->processPayment($user, $validated);

            return response()->json([
                'message' => 'Payment processed successfully.',
                'payment' => $payment,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Payment error',
                'error' => $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Payment success callback
     */
    public function success()
    {
        return response()->json(['message' => 'Payment succeeded']);
    }

    /**
     * Payment cancellation callback
     */
    public function cancel()
    {
        return response()->json(['message' => 'Payment cancelled']);
    }
}
