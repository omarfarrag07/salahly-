<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Offer extends Model
{
    //
    public function serviceRequest() {
        return $this->belongsTo(ServiceRequest::class);
    }

    public function provider() {
        return $this->belongsTo(Provider::class);
    }
}
