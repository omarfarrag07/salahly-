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

    /**
     * Check if request has valid location (lat and lng)
     */
    public function hasValidLocation(): bool
    {
        return !empty($this->lat) && !empty($this->lng);
    }

    /**
     * Check if request has a service assigned
     */
    public function hasService(): bool
    {
        return !empty($this->service_id);
    }

    /**
     * Check if request is ready for provider matching (has location and service)
     */
    public function isReadyForMatching(): bool
    {
        return $this->hasValidLocation() && $this->hasService();
    }

    /**
     * Ensure request is ready for provider matching
     * 
     * Validates both location and service, throwing specific exceptions for each.
     * Use this when you need validation with failure handling.
     * 
     * @throws InvalidArgumentException If location or service is missing
     */
    public function ensureReadyForMatching(): void
    {
        if (!$this->hasValidLocation()) {
            throw new \InvalidArgumentException('Service request does not have a valid location.');
        }

        if (!$this->hasService()) {
            throw new \InvalidArgumentException('Service request does not have a service assigned.');
        }
    }

    /**
     * Check if request is completed
     */
    public function isCompleted(): bool
    {
        return $this->status === 'completed';
    }

    /**
     * Check if request can be paid (must be completed and not already paid)
     */
    public function canBePaid(): bool
    {
        return $this->isCompleted() && !$this->isPaid();
    }

    /**
     * Check if request is already paid
     */
    public function isPaid(): bool
    {
        return $this->status === 'paid';
    }

    /**
     * Mark this request as paid
     * 
     * @return $this
     */
    public function markAsPaid(): self
    {
        $this->update(['status' => 'paid']);
        return $this;
    }

    /**
     * Update request details (non-state fields like title, description, location, etc.)
     * 
     * Use this for data updates. Use cancel(), complete(), markAsPaid() for state transitions.
     * 
     * @param array $data Fields to update
     * @return $this
     */
    public function updateDetails(array $data): self
    {
        $this->update($data);
        return $this;
    }

}
