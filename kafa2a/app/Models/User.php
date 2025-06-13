<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens; // <-- Add this line
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable; // <-- Add HasApiTokens here

    /** @use HasFactory<\Database\Factories\UserFactory> */
    

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'phone',
        'type',
        'service',
        'national_id',
        'address',
        'gender',
        'police_certificate_path',
        'selfie_path',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function newFromBuilder($attributes = [], $connection = null)
{
    $instance = parent::newFromBuilder($attributes, $connection);

    if (!empty($instance->type)) {
        $class = '\\App\\Models\\' . $instance->type;

        if (class_exists($class)) {
            $instance = (new $class)->newInstance([], true);
            $instance->setRawAttributes((array) $attributes, true);
        }
    }

    return $instance;
}

    public function isAdmin(): bool
    {
        return $this->type === 'admin';
    }
    public function isUser(): bool
    {
        return $this->type === 'user';
    }
    public function isProvider(): bool
    {
        return $this->type === 'Provider';
    }
    
    public function serviceRequests()
    {
        return $this->hasMany(ServiceRequest::class);
    }
    

    public function messages() {
        return $this->hasMany(Message::class);
    }

    public function ratings() {
        return $this->hasMany(Rating::class);
    }

    public function payments() {
        return $this->hasMany(Payment::class);
    }
    public function service()
    {
        return $this->hasOne(Service::class, 'provider_id', 'id');
    }

}
