<?php

namespace App\Listeners;

use App\Events\ChatStarted;
use App\Models\Chat;
use Illuminate\Support\Facades\Log;
use Illuminate\Foundation\Events\AsListener;

#[AsListener(event: ChatStarted::class)]
class StartChatListener
{
    public function handle(ChatStarted $event): void
    {
        Chat::firstOrCreate([
            'accepted_offer_id' => $event->chat_id,
        ], [
            'user_id' => $event->user_id,
            'provider_id' => $event->provider_id,
            'service_request_id' => $event->service_request_id,
        ]);

        Log::info("Chat created for accepted offer ID {$event->chat_id}");
    }
}
