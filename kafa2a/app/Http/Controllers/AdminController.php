<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Provider;
use App\Models\ServiceRequest;
use App\Models\Offer;
use App\Models\AcceptedOffer;
use App\Models\Category;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class AdminController extends Controller
{
    public function dashboard()
    {
        $usersCount = User::where('type','user')->count();
        $providersCount = User::where('type', 'Provider')->where('status', 'approved')->count();
        $PendingProvidersCount = User::where('type', 'Provider')->where('status', 'pending')->count();     

        return response()->json([
            'users' => $usersCount,
            'providers' => $providersCount,
            'PendingProviders'=>$PendingProvidersCount
        ]);
    }

    public function getAllUsers()
    {
        $users = User::where('type', 'user')->latest()->paginate(10);
        return response()->json($users);
    }

    public function getAllProviders()
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
    
    public function createProvider(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'service' => 'required|string|max:255',
            'national_id' => 'required|string|max:20|unique:users,national_id',
            'address' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'police_certificate' => 'required|file|mimes:pdf,jpg,jpeg,png|max:2048',
            'selfie' => 'required|file|mimes:jpg,jpeg,png|max:2048',
        ]);

        $policePath = $request->file('police_certificate')->store('police_certificates', 'public');
        $selfiePath = $request->file('selfie')->store('selfies', 'public');

        $provider = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'service' => $request->service,
            'national_id' => $request->national_id,
            'address' => $request->address,
            'phone' => $request->phone,
            'type' => 'Provider',
            'status' => 'approved',
            'police_certificate_path' => $policePath,
            'selfie_path' => $selfiePath,
        ]);

        return response()->json([
            'message' => 'Provider created successfully.',
            'provider' => $provider
        ], 201);
    }
    public function getAllServiceRequests()
    {
        $requests = ServiceRequest::with(['user', 'service'])->latest()->paginate(10);
        return response()->json($requests);
    }
    public function getServiceRequestById($id){
    $request = ServiceRequest::with(['user', 'service', 'offers'])->findOrFail($id);
    return response()->json($request);
    }
    
    public function reviewProviderStatus(Request $request, $id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
    
        $allowedStatuses = ['pending', 'approved', 'rejected', 'suspended'];
        $status = $request->input('status');
    
        if (!$status || !in_array($status, $allowedStatuses)) {
            return response()->json([
                'error' => 'Invalid status. Allowed values are: pending, approved, rejected, suspended.'
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
    public function getAllOffers()
    {
        $accepted = AcceptedOffer::with(['offer.provider', 'request.user'])->latest()->get();
    
        $unaccepted = Offer::whereNotIn('id', AcceptedOffer::pluck('offer_id'))
            ->with('provider')
            ->latest()
            ->get();
    
        return response()->json([
            'accepted_offers' => $accepted,
            'unaccepted_offers' => $unaccepted
        ]);
    }
   
    
}
