<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Admin extends User
{
    //aa333333333333333333333333333333333333
        protected $table = 'users';

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            $model->type = 'Admin';
        });
    }
}
