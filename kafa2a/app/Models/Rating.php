<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rating extends Model
{
    //
    public function user() {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function provider() {
        return $this->belongsTo(User::class, 'provider_id');
    }
}
