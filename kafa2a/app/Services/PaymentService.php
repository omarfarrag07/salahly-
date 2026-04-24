<?php

namespace App\Services;

use App\Models\AcceptedOffer;
use App\Models\Payment;
use App\Models\ServiceRequest;
use App\Models\User;
use App\Payment\CashPayment;
use App\Payment\PayPalPayment;
use App\Payment\StripePayment;
use App\Payment\CreditPayment;
use Exception;

/**
 * PaymentService - Orchestrates payment processing and workflow
 */
class PaymentService
{
    /**
     * Process payment for a service request
     * 
     * @param User $user The authenticated user (customer)
     * @param array $data Payment data including:
     *   - amount: float
     *   - gateway: string (paypal|stripe|cash|credit)
     *   - service_request_id: int
     *   - offer_id: int (optional)
     * @return Payment The created payment record
     * @throws Exception If payment fails or validation fails
     */
    public function processPayment(User $user, array $data): Payment
    {
        // Authorization: Only customers can pay
        if (!$user->isUser()) {
            throw new Exception('Only users can perform this action.');
        }

        // Get the service request
        $serviceRequest = ServiceRequest::findOrFail($data['service_request_id']);

        // Authorization: Can only pay for own requests
        if ($serviceRequest->user_id !== $user->id) {
            throw new Exception('You can only pay for your own service requests.');
        }

        // Business rule: Can't pay twice
        if (Payment::where('service_request_id', $data['service_request_id'])->exists()) {
            throw new Exception('Payment already made for this request');
        }

        // Business rule: Service must be completed before payment
        if ($serviceRequest->status !== 'completed') {
            throw new Exception('You can only pay after the service is completed.');
        }

        // Get the accepted offer and provider
        $offerId = $data['offer_id'] ?? null;
        $acceptedOffer = AcceptedOffer::where('offer_id', $offerId)->first();

        if (!$acceptedOffer) {
            throw new Exception('No offer found for this service request.');
        }

        // Get payment strategy based on gateway
        $strategy = $this->getPaymentStrategy($data['gateway']);

        try {
            // Process payment via selected gateway
            $payment = $strategy->pay([
                'user_id' => $user->id,
                'amount' => $data['amount'],
                'service_request_id' => $data['service_request_id'],
                'provider_id' => $acceptedOffer->provider_id,
                'offer_id' => $offerId,
            ]);
        } catch (Exception $e) {
            throw new Exception('Payment error: ' . $e->getMessage());
        }

        // Update related records on successful payment
        $this->updatePaymentRecords($acceptedOffer, $serviceRequest);

        return $payment;
    }

    /**
     * Get all payments (admin view)
     * 
     * @return \Illuminate\Database\Eloquent\Collection
     */
    public function getAllPayments()
    {
        return Payment::with(['user', 'provider', 'serviceRequest'])->get();
    }

    /**
     * Get payment strategy instance based on gateway type
     * 
     * @param string $gateway Gateway type (paypal|stripe|cash|credit)
     * @return \App\Payment\PaymentInterface
     * @throws Exception If gateway is invalid
     */
    private function getPaymentStrategy(string $gateway)
    {
        return match ($gateway) {
            'paypal' => new PayPalPayment(),
            'stripe' => new StripePayment(),
            'credit' => new CreditPayment(),
            'cash' => new CashPayment(),
            default => throw new Exception('Invalid payment gateway: ' . $gateway),
        };
    }

    /**
     * Update payment-related records (AcceptedOffer and ServiceRequest status)
     * 
     * @param AcceptedOffer $acceptedOffer
     * @param ServiceRequest $serviceRequest
     * @return void
     */
    private function updatePaymentRecords(AcceptedOffer $acceptedOffer, ServiceRequest $serviceRequest): void
    {
        // Mark accepted offer as paid
        $acceptedOffer->update(['status' => 'paid']);

        // Mark service request as paid
        $serviceRequest->update(['status' => 'paid']);
    }
}
