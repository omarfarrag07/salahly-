<?php

namespace App\Http\Controllers;

use App\Models\Rating;
use Illuminate\Http\Request;

class RatingController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'provider_id' => 'required|exists:users,id',
            'service_request_id' => 'required|exists:service_requests,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:500',
        ]);

        $existing = Rating::where('user_id', $validated['user_id'])
            ->where('service_request_id', $validated['service_request_id'])
            ->first();

        if ($existing) {
            return response()->json(['message' => 'You already rated this request'], 400);
        }

        $rating = Rating::create($validated);

        return response()->json($rating, 201);
    }

    public function index(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $ratings = Rating::where('user_id', $request->user_id)
            ->latest()
            ->paginate(10);

        return response()->json($ratings);
    }
}
