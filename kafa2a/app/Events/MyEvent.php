<?php
namespace App\Events;

use Illuminate\Queue\SerializesModels;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;



class MyEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $message;
    public $user_id;

    public function __construct($message, $user_id)
    {
        $this->message = $message;
        $this->user_id = $user_id;
    }

    public function broadcastOn()
    {
        // return ['my-channel'];
        return ['private-user.' . $this->user_id];
    }

    public function broadcastWith()
    {
        return [
            'message' => $this->message,
            'time' => now()->toDateTimeString()
        ];
    }

    public function broadcastAs()
    {
        return 'my-event';
    }
}