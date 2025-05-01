<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'type',
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

}
