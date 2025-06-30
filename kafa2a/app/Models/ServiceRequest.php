<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ServiceRequest extends Model
{
    protected $fillable = [
        'service_id',
        'title_en',
        'title_ar',
        'description_en',
        'description_ar',
        'location',
        'scheduled_at',
        'price',
        'status',
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function offers() {
        return $this->hasMany(Offer::class);
    }

    public function service() {
        return $this->belongsTo(Service::class);
    }
}
