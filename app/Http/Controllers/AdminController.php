<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\AdminService;

class AdminController extends Controller
{
    protected AdminService $adminService;

    public function __construct(AdminService $adminService)
    {
        $this->adminService = $adminService;
    }

    /**
     * Get dashboard statistics
     */
    public function dashboard()
    {
        $stats = $this->adminService->getDashboardStatistics();
        return response()->json($stats);
    }

    /**
     * Get all users with pagination
     */
    public function getAllUsers()
    {
        $users = $this->adminService->getAllUsers(10);
        return response()->json($users);
    }

    /**
     * Get all providers with pagination
     */
    public function getAllProviders()
    {
        $providers = $this->adminService->getAllProviders(10);
        return response()->json($providers);
    }

    /**
     * Get user by ID
     */
    public function getUserById($id)
    {
        try {
            $user = $this->adminService->getUserById($id);
            return response()->json($user);
        } catch (\Exception $e) {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    /**
     * Get provider by ID
     */
    public function getProviderById($id)
    {
        try {
            $provider = $this->adminService->getProviderById($id);
            return response()->json($provider);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Provider not found'], 404);
        }
    }

    /**
     * Delete a user
     */
    public function deleteUser($id)
    {
        try {
            $this->adminService->deleteUser($id);
            return response()->json(['message' => 'User deleted']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'User not found'], 404);
        }
    }

    /**
     * Get user count
     */
    public function countOfUsers()
    {
        $count = $this->adminService->countUsers();
        return response()->json(['users' => $count]);
    }

    /**
     * Get provider count
     */
    public function countOfProviders()
    {
        $count = $this->adminService->countProviders();
        return response()->json(['providers' => $count]);
    }

    /**
     * Get pending providers
     */
    public function getPendingProviders()
    {
        $providers = $this->adminService->getPendingProviders();
        return response()->json($providers);
    }

    /**
     * Get approved and suspended providers
     */
    public function getApprovedSuspendedProviders()
    {
        $providers = $this->adminService->getApprovedAndSuspendedProviders();
        return response()->json($providers);
    }

    /**
     * Get authenticated admin's profile
     */
    public function AdminProfile()
    {
        $admin = auth()->user();
        $profile = $this->adminService->getAdminProfile($admin);
        return response()->json($profile);
    }

    /**
     * Create a new provider
     */
    public function createProvider(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'service_id' => 'required|string|max:255',
            'national_id' => 'required|string|max:20|unique:users,national_id',
            'address' => 'required|string|max:255',
            'phone' => ['required', 'string', 'max:20', 'unique:users,phone'],
            'police_certificate' => 'required|file|mimes:pdf,jpg,jpeg,png|max:2048',
            'selfie' => 'required|file|mimes:jpg,jpeg,png|max:2048',
        ]);

        try {
            // Store uploaded files
            $policePath = $request->file('police_certificate')->store('certificates', 'public');
            $selfiePath = $request->file('selfie')->store('selfies', 'public');

            $providerData = array_merge($request->validated(), [
                'police_certificate_path' => $policePath,
                'selfie_path' => $selfiePath,
            ]);

            $provider = $this->adminService->createProvider($providerData);

            return response()->json([
                'message' => 'Provider created successfully.',
                'provider' => $provider
            ], 201);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error creating provider: ' . $e->getMessage()], 400);
        }
    }

    /**
     * Get all service requests with pagination
     */
    public function getAllServiceRequests()
    {
        $requests = $this->adminService->getAllServiceRequests(10);
        return response()->json($requests);
    }

    /**
     * Get service request by ID
     */
    public function getServiceRequestById($id)
    {
        try {
            $request = $this->adminService->getServiceRequestById($id);
            return response()->json($request);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Service request not found'], 404);
        }
    }

    /**
     * Review and update provider status
     */
    public function reviewProviderStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|string|in:pending,approved,rejected,suspended',
            'suspend_reason' => 'required_if:status,suspended|string|max:1000',
        ]);

        try {
            $provider = $this->adminService->updateProviderStatus(
                $id,
                $request->status,
                $request->suspend_reason
            );

            return response()->json([
                'message' => 'Provider status updated successfully.',
                'provider' => $provider,
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 422);
        }
    }

    /**
     * Get all offers (accepted and unaccepted)
     */
    public function getAllOffers()
    {
        $offers = $this->adminService->getAllOffers();
        return response()->json($offers);
    }
}
