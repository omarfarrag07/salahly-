<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

use App\Events\ChatStarted;
use App\Listeners\StartChatListener;

class EventServiceProvider extends ServiceProvider
{
    protected $listen = [
        ChatStarted::class => [
            StartChatListener::class,
        ],
    ];

    public function boot(): void
    {
        //
    }
}
