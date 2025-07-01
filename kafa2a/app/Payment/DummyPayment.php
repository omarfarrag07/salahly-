<?php

namespace App\Payment;

use App\Models\Payment;
use Illuminate\Support\Carbon;

class DummyPayment implements PaymentInterface
{
    public function pay(array $data)
    {
        return Payment::create([
            'user_id' => $data['user_id'],
            'provider_id' => $data['provider_id'],
            'service_request_id' => $data['service_request_id'],
            'amount' => $data['amount'],
            'gateway' => 'dummy',
            'status' => 'paid',
            'transaction_id' => uniqid(rand(1000, 9999), true),
            'paid_at' => Carbon::now(),
        ]);
    }
}
