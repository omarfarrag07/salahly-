<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Offer extends Model
{
    //
    protected $fillable = [
        'service_request_id',
        'provider_id',
        'price',
        'status',
    ];
    public function serviceRequest() {
        return $this->belongsTo(ServiceRequest::class);
    }

    public function provider() {
        return $this->belongsTo(User::class);
    }
}
