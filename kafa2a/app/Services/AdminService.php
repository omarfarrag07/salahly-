<?php

namespace App\Services;

use App\Models\User;
use App\Models\ServiceRequest;
use App\Models\Offer;
use App\Models\AcceptedOffer;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\Hash;

/**
 * AdminService - Handles admin dashboard queries and provider management
 */
class AdminService
{
    /**
     * Get dashboard statistics
     * 
     * @return array Dashboard metrics
     */
    public function getDashboardStatistics(): array
    {
        $usersCount = User::where('type', 'user')->count();
        $approvedProvidersCount = User::where('type', 'Provider')->where('status', 'approved')->count();
        $suspendedProvidersCount = User::where('type', 'Provider')->where('status', 'suspended')->count();
        $providersCount = $approvedProvidersCount + $suspendedProvidersCount;
        $pendingProvidersCount = User::where('type', 'Provider')->where('status', 'pending')->count();

        return [
            'users' => $usersCount,
            'approvedProviders' => $approvedProvidersCount,
            'suspendedProviders' => $suspendedProvidersCount,
            'providers' => $providersCount,
            'pendingProviders' => $pendingProvidersCount,
        ];
    }

    /**
     * Get all users with pagination
     * 
     * @param int $perPage Items per page
     * @return LengthAwarePaginator
     */
    public function getAllUsers(int $perPage = 10): LengthAwarePaginator
    {
        return User::where('type', 'user')->latest()->paginate($perPage);
    }

    /**
     * Get all providers with pagination
     * 
     * @param int $perPage Items per page
     * @return LengthAwarePaginator
     */
    public function getAllProviders(int $perPage = 10): LengthAwarePaginator
    {
        return User::where('type', 'Provider')->latest()->paginate($perPage);
    }

    /**
     * Get user by ID
     * 
     * @param int $id User ID
     * @return User
     */
    public function getUserById(int $id): User
    {
        return User::where('type', 'user')->findOrFail($id);
    }

    /**
     * Get provider by ID
     * 
     * @param int $id Provider ID
     * @return User
     */
    public function getProviderById(int $id): User
    {
        return User::where('type', 'Provider')->findOrFail($id);
    }

    /**
     * Delete a user
     * 
     * @param int $id User ID
     * @return void
     */
    public function deleteUser(int $id): void
    {
        $user = User::findOrFail($id);
        $user->delete();
    }

    /**
     * Get count of all users
     * 
     * @return int
     */
    public function countUsers(): int
    {
        return User::where('type', 'user')->count();
    }

    /**
     * Get count of all providers
     * 
     * @return int
     */
    public function countProviders(): int
    {
        return User::where('type', 'Provider')->count();
    }

    /**
     * Get pending providers
     * 
     * @return Collection
     */
    public function getPendingProviders(): Collection
    {
        return User::where('type', 'Provider')
            ->where('status', 'pending')
            ->latest()
            ->get();
    }

    /**
     * Get approved or suspended providers
     * 
     * @return Collection
     */
    public function getApprovedAndSuspendedProviders(): Collection
    {
        return User::where('type', 'Provider')
            ->whereIn('status', ['approved', 'suspended'])
            ->latest()
            ->get();
    }

    /**
     * Get admin profile
     * 
     * @param User $admin Authenticated admin
     * @return array Admin profile data
     */
    public function getAdminProfile(User $admin): array
    {
        return [
            'name' => $admin->name,
            'email' => $admin->email,
            'phone' => $admin->phone,
        ];
    }

    /**
     * Create a new provider
     * 
     * @param array $data Provider data
     * @return User The created provider
     */
    public function createProvider(array $data): User
    {
        $provider = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'service_id' => $data['service_id'],
            'national_id' => $data['national_id'],
            'address' => $data['address'],
            'phone' => $data['phone'],
            'type' => 'Provider',
            'status' => 'approved',
            'police_certificate_path' => $data['police_certificate_path'] ?? null,
            'selfie_path' => $data['selfie_path'] ?? null,
        ]);

        return $provider;
    }

    /**
     * Get all service requests with pagination
     * 
     * @param int $perPage Items per page
     * @return LengthAwarePaginator
     */
    public function getAllServiceRequests(int $perPage = 10): LengthAwarePaginator
    {
        return ServiceRequest::with(['user', 'service'])->latest()->paginate($perPage);
    }

    /**
     * Get service request by ID with details
     * 
     * @param int $id Request ID
     * @return ServiceRequest
     */
    public function getServiceRequestById(int $id): ServiceRequest
    {
        return ServiceRequest::with(['user', 'service', 'acceptedOffer.offer.provider'])->findOrFail($id);
    }

    /**
     * Review and update provider status
     * 
     * @param int $providerId Provider ID
     * @param string $status New status (pending|approved|rejected|suspended)
     * @param string|null $suspendReason Reason for suspension (required if status is suspended)
     * @return User Updated provider
     * @throws \Exception If invalid status or missing suspension reason
     */
    public function updateProviderStatus(int $providerId, string $status, ?string $suspendReason = null): User
    {
        $allowedStatuses = ['pending', 'approved', 'rejected', 'suspended'];

        if (!in_array($status, $allowedStatuses)) {
            throw new \Exception('Invalid status. Allowed values are: ' . implode(', ', $allowedStatuses));
        }

        if ($status === 'suspended' && empty($suspendReason)) {
            throw new \Exception('Suspension reason is required.');
        }

        $provider = User::where('type', 'Provider')->findOrFail($providerId);
        $provider->status = $status;
        $provider->suspend_reason = $status === 'suspended' ? $suspendReason : null;
        $provider->save();

        return $provider;
    }

    /**
     * Get all offers (both accepted and unaccepted)
     * 
     * @return array Array with 'accepted_offers' and 'unaccepted_offers'
     */
    public function getAllOffers(): array
    {
        $accepted = AcceptedOffer::with(['offer.provider', 'request.user'])->latest()->get();

        $unaccepted = Offer::whereNotIn('id', AcceptedOffer::pluck('offer_id'))
            ->with('provider')
            ->latest()
            ->get();

        return [
            'accepted_offers' => $accepted,
            'unaccepted_offers' => $unaccepted,
        ];
    }
}
