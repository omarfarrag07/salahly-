<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class NewOfferNotification extends Notification
{
    use Queueable;

    private $offer;
    /**
     * Create a new notification instance.
     */
    public function __construct($offer)
    {
        $this->offer = $offer;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via($notifiable)
    {
        return ['database', 'broadcast'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toArray($notifiable)
    {
        return [
            'id' => $this->offer->id,
            'title' => 'New Offer Created',
            'body' => 'You have a new offer from provider ' . $this->offer->provider_id,
        ];
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toBroadcast($notifiable)
    {
        return [
            'id' => $this->offer->id,
            'title' => 'New Offer Created',
            'body' => 'You have a new offer from provider ' . $this->offer->provider_id,
        ];
    }
}
