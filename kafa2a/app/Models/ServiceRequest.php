<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ServiceRequest extends Model
{
    protected $fillable = [
        'service_id',
        'title',
        'description',
        'address',
        'lat',
        'lng',
        'scheduled_at',
        'price',
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function offers()
    {
        return $this->hasMany(Offer::class);
    }

    public function service()
    {
        return $this->belongsTo(Service::class);
    }
    public function payment()
    {
        return $this->hasOne(Payment::class);
    }
    public function ratings()
    {
        return $this->hasMany(Rating::class);
    }

    public function acceptedOffer()
    {
        return $this->hasOne(AcceptedOffer::class);
    }

    /**
     * Check if request is in pending status
     */
    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    /**
     * Check if request can be deleted (only pending requests)
     */
    public function canBeDeleted(): bool
    {
        return $this->isPending();
    }

    /**
     * Cancel this pending request
     * 
     * @throws \Illuminate\Validation\ValidationException If not pending
     * @return $this
     */
    public function cancel(): self
    {
        if (!$this->isPending()) {
            throw \Illuminate\Validation\ValidationException::withMessages([
                'status' => 'Only pending requests can be canceled.',
            ]);
        }

        $this->update(['status' => 'canceled']);
        return $this;
    }

    /**
     * Mark request as completed
     * @return $this
     */
    public function complete(): self
    {
        $this->update(['status' => 'completed']);
        return $this;
    }

}
