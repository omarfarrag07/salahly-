<?php

namespace App\Services;

use App\Models\ServiceRequest;
use App\Models\User;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

/**
 * ServiceRequestService - Manages service request lifecycle and state transitions
 */
class ServiceRequestService
{
    /**
     * Get pending requests for authenticated user
     */
    public function getPendingRequests(User $user, array $filters = [], int $perPage = 10): LengthAwarePaginator
    {
        return $this->userRequestsQuery($user, $filters)
            ->where('status', 'pending')
            ->latest()
            ->paginate($perPage);
    }

    /**
     * Get all requests for authenticated user with any status
     */
    public function getAllUserRequests(User $user, array $filters = [], int $perPage = 10): LengthAwarePaginator
    {
        return $this->userRequestsQuery($user, $filters)
            ->latest()
            ->paginate($perPage);
    }

    /**
     * Create a new service request
     * 
     * @param User $user The authenticated user (customer)
     * @param array $data Request data
     * @return ServiceRequest
     */
    public function createRequest(User $user, array $data): ServiceRequest
    {
        return DB::transaction(function () use ($user, $data) {
            return $user->serviceRequests()->create([
                ...$data,
                'status' => 'pending',
            ]);
        });
    }

    /**
     * Get request details with pending offers
     * 
     * @param int $id Request ID
     * @return ServiceRequest
     */
    public function getRequestDetails(int $id): ServiceRequest
    {
        return ServiceRequest::with([
            'user',
            'service',
            'offers' => function ($query) {
                $query->where('status', 'pending')->with(['provider', 'serviceRequest']);
            }
        ])->findOrFail($id);
    }

    /**
     * Update a service request
     */
    public function updateRequest(int $id, User $user, array $data): ServiceRequest
    {
        $request = $this->getOwnedRequest($id, $user);
        $request->updateDetails($data);
        return $request;
    }

    /**
     * Delete a service request (only pending requests can be deleted)
     */
    public function deleteRequest(int $id, User $user): void
    {
        $request = $this->getOwnedRequest($id, $user);

        if (!$request->canBeDeleted()) {
            throw ValidationException::withMessages([
                'status' => 'Only pending requests can be deleted.',
            ]);
        }

        $request->delete();
    }

    /**
     * Cancel a pending service request
     */
    public function cancelRequest(int $id, User $user): ServiceRequest
    {
        $request = $this->getOwnedRequest($id, $user);
        return $request->cancel();
    }

    /**
     * Mark a service request as completed
     */
    public function completeRequest(int $id): ServiceRequest
    {
        $request = ServiceRequest::findOrFail($id);
        return $request->complete();
    }

    /**
     * Get owned request with ownership validation
     * 
     * @throws AuthorizationException If user doesn't own the request
     * @throws ModelNotFoundException If request doesn't exist
     */
    private function getOwnedRequest(int $id, User $user): ServiceRequest
    {
        $request = ServiceRequest::findOrFail($id);

        if ($request->user_id !== $user->id) {
            throw new AuthorizationException('You are not authorized to access this request.');
        }

        return $request;
    }

    /**
     * Build base query for user requests with relationships and optional filters
     */
    private function userRequestsQuery(User $user, array $filters = [])
    {
        $query = ServiceRequest::with(['service', 'user'])
            ->where('user_id', $user->id);

        if (!empty($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        if (!empty($filters['service_id'])) {
            $query->where('service_id', $filters['service_id']);
        }

        return $query;
    }
}
