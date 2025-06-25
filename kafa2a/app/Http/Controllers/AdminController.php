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
        $usersCount = User::where('type','user')->count();
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
        $users = User::where('type', 'user')->latest()->paginate(10);
        return response()->json($users);
    }

    public function allProviders()
    {
        $providers = User::where('type', 'Provider')->latest()->paginate(10);
        return response()->json($providers);
    }
    public function getUserById($id)
    {

        $User = User::where('type', 'user')->findOrFail($id);
        return response()->json($User);
    }
 
    
    public function getProviderById($id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
        return response()->json($provider);
    }
    public function deleteUser($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json(['message' => 'User deleted']);
    }


    public function countOfUsers()
    {
        $usersCount = User::where('type', 'user')->count();
        return response()->json(['users' => $usersCount]);
       
    }
    public function countOfProviders()
    {

        $providersCount = User::where('type', 'Provider')->count();
        return response()->json([ 'providers' => $providersCount]);
    }
    public function getPendingProviders()
    {
        $providers = User::where('type', 'Provider')->where('status', 'pending')->latest()->get();
        return response()->json($providers);
    }
    // public function getAcceptedRequests()
    // {
    //     $requests = ServiceRequest::with(['user', 'service'])->latest()->paginate(10);
    //     return response()->json($requests);
    // }

    public function allRequests()
    {
        $requests = ServiceRequest::with(['user', 'service'])->latest()->paginate(10);
        return response()->json($requests);
    }
    public function getRequestByID($id){
    $request = ServiceRequest::with(['user', 'service', 'offers'])->findOrFail($id);
    return response()->json($request);
    }
    
    public function reviewProviderStatus(Request $request, $id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
    
        $allowedStatuses = ['pending', 'accepted', 'rejected', 'suspended'];
        $status = $request->input('status');
    
        if (!$status || !in_array($status, $allowedStatuses)) {
            return response()->json([
                'error' => 'Invalid status. Allowed values are: pending, accepted, rejected, suspended.'
            ], 422);
        }
    
        $suspendReason = $request->input('suspend_reason');
        if ($status === 'suspended' && (empty($suspendReason))) {
            return response()->json([
                'error' => 'Suspension reason is required and must be less than 1000 characters.'
            ], 422);
        }

    
        $provider->status = $status;
        $provider->suspend_reason = $status === 'suspended' ? $suspendReason : null;
        $provider->save();
    
        return response()->json([
            'message' => 'Provider status updated successfully.'
        ]);
    }
    
}
