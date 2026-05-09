<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Events\MessageSent;
use App\Models\Message;

class MessageController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(User $user)
    {
        $messages = Message::whith('sender', 'receiver')
        ->whereIn('sender_id', [$user->id, auth()->id()])
        ->whereIn('receiver_id', [$user->id, auth()->id()])
        ->get();
            
        return response()->json($messages);
    }
    


    public function send(Request $request)
    {
        // $message = Message::create([
        //     'sender_id' => auth()->id(),
        //     'receiver_id' => $request->receiver_id,
        //     'content' => $request->content,
        // ]);

        // broadcast(new MessageSent($message))->toOthers();

        // return response()->json($message);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(User $user,Request $request)
    {
        $message = Message::create([
            'service_request_id' => $request->service_request_id,
            'sender_id' => auth()->id(),
            'receiver_id' => $user->id,
            'message' => $request->message,
        ]);

        broadcast(new MessageSent($user, $message))->toOthers();

        return response()->json($message);

    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
