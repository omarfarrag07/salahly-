<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    protected $fillable = [
        'user_id',
        'provider_id',
        'service_request_id',
        'offer_id', // Nullable foreign key to AcceptedOffer
        'gateway',
        'amount',
        'status',
        'transaction_id',
        'paid_at',
    ];

    protected $casts = [
        'paid_at' => 'datetime',
        'amount' => 'decimal:2',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function provider(): BelongsTo
    {
        return $this->belongsTo(User::class, 'provider_id');
    }
    public function serviceRequest(): BelongsTo
    {
        return $this->belongsTo(ServiceRequest::class);
    }
    public function offer(): BelongsTo
    {
        return $this->belongsTo(AcceptedOffer::class, 'offer_id');
    }

    /**
     * Query scope: Check if payment already exists for a service request
     * 
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @param int $serviceRequestId
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeForServiceRequest($query, int $serviceRequestId)
    {
        return $query->where('service_request_id', $serviceRequestId);
    }

    /**
     * Check if payment exists for a service request
     * 
     * @param int $serviceRequestId
     * @return bool
     */
    public static function existsForRequest(int $serviceRequestId): bool
    {
        return self::forServiceRequest($serviceRequestId)->exists();
    }

}
