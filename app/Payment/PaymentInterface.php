<?php

namespace App\Payment;

interface PaymentInterface
{
    public function pay(array $data);
}
