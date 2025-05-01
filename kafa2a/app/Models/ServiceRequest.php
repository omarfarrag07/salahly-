<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ServiceRequest extends Model
{
    //
    public function user() {
        return $this->belongsTo(User::class);
    }

    public function offers() {
        return $this->hasMany(Offer::class);
    }
}
