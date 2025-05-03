<?php

namespace App\Events;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class ChatStarted
{
    use Dispatchable, SerializesModels;

    public $chat_id;
    public $user_id;
    public $provider_id;
    public $service_request_id;

    public function __construct(array $data)
    {
        $this->chat_id = $data['chat_id'];
        $this->user_id = $data['user_id'];
        $this->provider_id = $data['provider_id'];
        $this->service_request_id = $data['service_request_id'];
    }
}
