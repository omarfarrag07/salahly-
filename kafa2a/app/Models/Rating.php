<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rating extends Model
{
    protected $fillable = ['user_id', 'provider_id', 'service_request_id', 'offer_id', 'rating', 'review'];
    //
    public function user() {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function provider() {
        return $this->belongsTo(User::class, 'provider_id');
    }
    public function serviceRequest()
{
    return $this->belongsTo(ServiceRequest::class);
}

    public function offer()
    {
        return $this->belongsTo(AcceptedOffer::class, 'offer_id');
    }

}
