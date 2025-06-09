<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Provider;
use App\Models\ServiceRequest;
use App\Models\Offer;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function dashboard()
    {
        $usersCount = User::count();
        $providersCount = User::where('type', 'Provider')->count();
        $requestsCount = ServiceRequest::count();
        $offersCount = Offer::count();

        return response()->json([
            'users' => $usersCount,
            'providers' => $providersCount,
            'requests' => $requestsCount,
            'offers' => $offersCount
        ]);
    }

    public function allUsers()
    {
        $users = User::where('type', 'User')->latest()->paginate(10);
        return response()->json($users);
    }

    public function allProviders()
    {
        $providers = User::where('type', 'Provider')->latest()->paginate(10);
        return response()->json($providers);
    }

    public function allRequests()
    {
        $requests = ServiceRequest::with(['user', 'service'])->latest()->paginate(10);
        return response()->json($requests);
    }

    public function deleteUser($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json(['message' => 'User deleted']);
    }
    
    public function reviewProviderStatus(Request $request, $userId)
    {
        $request->validate([
            'status' => 'required|in:accepted,refused,suspended',
            'suspend_reason' => 'nullable|string|max:1000',
        ]);
    
        $user = User::where('type', 'Provider')->findOrFail($userId);
        $provider = $user->provider;
    
        if (!$provider) {
            return response()->json(['error' => 'Provider profile not found.'], 404);
        }
    
        if ($request->status === 'suspended' && empty($request->suspend_reason)) {
            return response()->json(['error' => 'Suspension reason is required.'], 422);
        }
    
        $provider->status = $request->status;
        $provider->suspend_reason = $request->status === 'suspended' ? $request->suspend_reason : null;
        $provider->save();
    
        return response()->json(['message' => 'Provider status updated successfully.']);
    }
    

}
