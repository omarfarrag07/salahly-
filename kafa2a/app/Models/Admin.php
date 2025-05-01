<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Admin extends User
{
    //
    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            $model->type = 'Admin';
        });
    }
}
