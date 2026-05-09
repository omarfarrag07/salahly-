<?php

namespace App\Events;

use App\Models\Message;
use App\Models\User;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\InteractsWithSockets;

class MessageSent implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels, Dispatchable;

    public $message;
    public $user;

    public function __construct(User $user, Message $message)
    {
        $this->user = $user;
        $this->message = $message;
        \Log::info('MessageSent event triggered', ['user' => $user->id, 'message' => $message->id]);
    }

    public function broadcastOn()
    {
        // return new Channel('chat.' . $this->message->receiver_id); // Dynamic private channel
        // return[
        //     new PrivateChannel("chat"),
        // ];
        return [
            new PrivateChannel("chat." . $this->message->receiver_id),
        ];
    }

    public function broadcastWith()
    {
        // return [
        //     'message' => $this->message->load('sender') // Include sender info
        // ];
        \Log::info('Broadcasting message:', ['message' => $this->message]);

        return ['message' => $this->message];


    }
}
