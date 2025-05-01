<?php

namespace App\Http\Controllers;

use App\Models\User;
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
}
