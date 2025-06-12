<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Provider extends User
{

    protected $table = 'users';

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

    public function service()
    {
        return $this->hasOne(Service::class, 'provider_id', 'id');
    }

}
