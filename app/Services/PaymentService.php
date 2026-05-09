<?php

namespace App\Services;

use App\Models\AcceptedOffer;
use App\Models\Payment;
use App\Models\ServiceRequest;
use App\Models\User;
use InvalidArgumentException;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Support\Facades\DB;

/**
 * PaymentService - Orchestrates payment processing and workflow
 * 
 * Responsibilities:
 * - Validate payment prerequisites using model methods
 * - Select and invoke appropriate payment strategy
 * - Coordinate atomic updates (payment + offer + request in transaction)
 * 
 * Business rules are delegated to models (ServiceRequest::canBePaid(), etc.)
 */
class PaymentService
{
    /**
     * Process payment for a service request
     * 
     * Entire flow is atomic: payment, offer, and request are updated together in a transaction.
     * All validation delegated to model methods for reusability.
     * 
     * @param User $user The authenticated user (customer)
     * @param array $data Payment data including:
     *   - amount: float
     *   - gateway: string (paypal|stripe|cash|credit)
     *   - service_request_id: int
     *   - offer_id: int
     * @return Payment The created payment record
     * 
     * @throws AuthorizationException If user cannot pay this request
     * @throws InvalidArgumentException If data is invalid or prerequisites unmet
     */
    public function processPayment(User $user, array $data): Payment
    {
        // Validate required fields
        $this->validatePaymentData($data);

        // Fetch service request (will throw ModelNotFoundException if not found)
        $serviceRequest = ServiceRequest::findOrFail($data['service_request_id']);

        // Validate authorization: User must own the request
        if ($serviceRequest->user_id !== $user->id) {
            throw new AuthorizationException('You can only pay for your own service requests.');
        }

        // Fetch and validate accepted offer
        $acceptedOffer = AcceptedOffer::find($data['offer_id']);
        if (!$acceptedOffer || !$acceptedOffer->belongsToRequest($serviceRequest)) {
            throw new InvalidArgumentException('Offer does not belong to this service request.');
        }

        // Validate business prerequisites using model methods
        if (!$serviceRequest->canBePaid()) {
            throw new InvalidArgumentException('You can only pay after the service is completed and has not been paid yet.');
        }

        // Get payment strategy (using service container)
        $strategy = $this->resolvePaymentStrategy($data['gateway']);

        // Process payment within atomic transaction
        return DB::transaction(function () use ($user, $data, $serviceRequest, $acceptedOffer, $strategy) {
            // Process payment via selected gateway
            $payment = $strategy->pay([
                'user_id' => $user->id,
                'amount' => $data['amount'],
                'service_request_id' => $data['service_request_id'],
                'provider_id' => $acceptedOffer->provider_id,
                'offer_id' => $data['offer_id'],
            ]);

            // Update state using model methods (guaranteed atomicity)
            $serviceRequest->markAsPaid();
            $acceptedOffer->markAsPaid();

            return $payment;
        });
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
     * PRIVATE: Validate payment data structure and required fields
     * 
     * @param array $data
     * @throws InvalidArgumentException If required fields missing
     */
    private function validatePaymentData(array $data): void
    {
        if (empty($data['service_request_id'])) {
            throw new InvalidArgumentException('service_request_id is required.');
        }
        if (empty($data['offer_id'])) {
            throw new InvalidArgumentException('offer_id is required.');
        }
        if (empty($data['amount']) || $data['amount'] <= 0) {
            throw new InvalidArgumentException('amount must be positive.');
        }
        if (empty($data['gateway'])) {
            throw new InvalidArgumentException('gateway is required.');
        }
    }

    /**
     * PRIVATE: Resolve payment strategy from service container
     * 
     * Uses Laravel's service container (app) instead of direct instantiation.
     * Keeps strategy selection clean, testable, and mockable.
     * 
     * Strategy classes must be registered in service container or resolvable.
     * 
     * @param string $gateway Gateway type (paypal|stripe|cash|credit)
     * @return \App\Payment\PaymentInterface
     * 
     * @throws InvalidArgumentException If gateway is invalid or not resolvable
     */
    private function resolvePaymentStrategy(string $gateway)
    {
        $strategyMap = [
            'paypal' => 'App\\Payment\\PayPalPayment',
            'stripe' => 'App\\Payment\\StripePayment',
            'credit' => 'App\\Payment\\CreditPayment',
            'cash' => 'App\\Payment\\CashPayment',
        ];

        if (!isset($strategyMap[$gateway])) {
            throw new InvalidArgumentException("Invalid payment gateway: {$gateway}. Supported: " . implode(', ', array_keys($strategyMap)));
        }

        $class = $strategyMap[$gateway];
        try {
            return app($class);
        } catch (\Exception $e) {
            throw new InvalidArgumentException("Cannot resolve payment strategy for gateway '{$gateway}': " . $e->getMessage());
        }
    }
}
