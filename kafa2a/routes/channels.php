<?php

use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Auth;

// Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
//     return (int) $user->id === (int) $id;
// });

Broadcast::channel('chat.{receiverId}', function ($user, $receiverId) {
    // Check if the user is authenticated and if the receiver_id matches the current user
    return Auth::check() && (int) $user->id === (int) $receiverId;
});

