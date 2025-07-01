<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AcceptedOffer extends Model
{
    const PAYMENT_CASH = 'cash';
    const PAYMENT_CREDIT = 'credit';

    protected $fillable = [
        'service_request_id', 'offer_id',
        'payment_method', 'payment_status'
    ];

    public function request()
    {
        return $this->belongsTo(ServiceRequest::class, 'service_request_id');
    }

    public function offer()
    {
        return $this->belongsTo(Offer::class);
    }

    public function user()
    {
        return this->belongsTo(User::class, 'user_id'); // who accepted the offer
    }
    public function provider()
    {
        return $this->belongsTo(User::class, 'provider_id'); // who provided the service
    }

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }

    public function messages()
    {
        return $this->hasMany(Message::class);
    }
}