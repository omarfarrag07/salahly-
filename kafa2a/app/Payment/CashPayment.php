<?php

namespace App\Payment;

use App\Models\Payment;

class CashPayment implements PaymentInterface
{
    public function pay(array $data)
    {
        return Payment::create([
            'user_id' => auth()->id(),
            'provider_id' => $data['provider_id'],
            'service_request_id' => $data['service_request_id'],
            'amount' => $data['amount'],
            'gateway' => 'cash',
            'status' => 'pending', // cash will be confirmed manually
            'transaction_id' => uniqid(rand(1000, 9999), true),
            'paid_at' => null,
        ]);
    }
}
