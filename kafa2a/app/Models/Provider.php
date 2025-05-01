<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Provider extends User
{

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->type = 'Provider';
        });
    }


    public function offers()
    {
        return $this->hasMany(Offer::class);
    }


}
