<?php

namespace App\Http\Controllers;

use App\Models\Rating;
use App\Models\User;
use Illuminate\Http\Request;
use App\Models\AcceptedOffer;


class RatingController extends Controller
{

    public function store(Request $request)
    {
        $user = auth()->user();
    
        if (!$user->isUser()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
    
        $validated = $request->validate([
            'service_request_id' => 'required|exists:service_requests,id',
            'rating' => 'required|integer|min:1|max:5',
            'review' => 'nullable|string|max:10000',
        ]);
    
        $serviceRequest = \App\Models\ServiceRequest::where('id', $validated['service_request_id'])
            ->where('user_id', $user->id)
            ->first();
    
        if (!$serviceRequest) {
            return response()->json(['message' => 'You can only rate your own service requests.'], 403);
        }
    
        if ($serviceRequest->status !== 'paid') {
            return response()->json(['message' => 'You can only rate after payment is completed.'], 403);
        }
    
        $existing = Rating::where('user_id', $user->id)
            ->where('service_request_id', $validated['service_request_id'])
            ->first();
    
        if ($existing) {
            return response()->json(['message' => 'You already rated this request'], 400);
        }
    
        $offer = \App\Models\Offer::where('service_request_id', $validated['service_request_id'])->first();
    
        if (!$offer) {
            return response()->json(['message' => 'No offer found for this request'], 404);
        }
    
        $providerId = $offer->provider_id;
    
        $rating = Rating::create([
            'user_id' => $user->id,
            'provider_id' => $providerId,
            'service_request_id' => $validated['service_request_id'],
            'rating' => $validated['rating'],
            'review' => $validated['review'] ?? null,
        ]);
    
        $this->updateBayesianRating($providerId, $validated['rating']);
    
        return response()->json($rating, 201);
    }
    

    public function show($id)
    {
        $rating = Rating::findOrFail($id);
        return response()->json($rating);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'review' => 'nullable|string|max:500',
        ]);

        $rating = Rating::findOrFail($id);
        $rating->update($validated);

        $this->updateBayesianRating($rating->provider_id, $validated['rating']);

        return response()->json($rating);
    }

    public function destroy($id)
    {
        $rating = Rating::findOrFail($id);
        $providerId = $rating->provider_id;
        $rating->delete();

        $this->recalculateBayesianRatingAfterDeletion($providerId);

        return response()->json(['message' => 'Rating deleted successfully']);
    }

    private function updateBayesianRating($providerId, $newRating)
    {
        $totalRatings = Rating::where('provider_id', $providerId)->count();
        $sumRatings = Rating::where('provider_id', $providerId)->sum('rating');

        if ($totalRatings === 0) {
            $bayesian = $newRating;
        } else {
            $overallAvg = Rating::avg('rating') ?? 5;
            $existingSum = $sumRatings - $newRating;
            $existingCount = $totalRatings - 1;

            $bayesian = (($overallAvg * $existingCount) + $newRating) / $totalRatings;
        }

        User::where('id', $providerId)->update([
            'rating' => (int) round($bayesian)  // Ensure TINYINT compatibility
        ]);
    }

    private function recalculateBayesianRatingAfterDeletion($providerId)
    {
        $ratings = Rating::where('provider_id', $providerId);
        $totalRatings = $ratings->count();
        $sumRatings = $ratings->sum('rating');

        if ($totalRatings === 0) {
            $bayesian = 5; // Default fallback
        } else {
            $overallAvg = Rating::avg('rating') ?? 5;
            $bayesian = (($overallAvg * $totalRatings) + $sumRatings) / ($totalRatings * 2);
        }

        User::where('id', $providerId)->update([
            'rating' => (int) round($bayesian)  // Ensure TINYINT compatibility
        ]);
    }
    public function getProviderRatingAndReviews($providerId)
{
    $provider = User::where('id', $providerId)
        ->where('type', 'Provider')
        ->firstOrFail();

    $reviews = Rating::with('user:id,name')
        ->where('provider_id', $providerId)
        ->latest()
        ->take(5)
        ->get(['id', 'user_id', 'rating', 'review']);

    return response()->json([
        'provider_name' => $provider->name,
        'rating' => $provider->rating, 
        'reviews' => $reviews
    ]);
}

}
