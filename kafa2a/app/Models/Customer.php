<?php


namespace App\Models;

class Customer extends User
{
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $model->type = 'user';
        });
    }
}