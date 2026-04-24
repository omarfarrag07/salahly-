<?php

namespace App\Http\Controllers;

use App\Models\ServiceRequest;
use Illuminate\Http\Request;
use App\Services\ServiceRequestService;

class ServiceRequestController extends Controller
{
    protected ServiceRequestService $serviceRequestService;

    public function __construct(ServiceRequestService $serviceRequestService)
    {
        $this->serviceRequestService = $serviceRequestService;
    }

    /**
     * Get pending requests for authenticated user
     */
    public function index()
    {
        $filters = [
            'status' => request('status'),
            'service_id' => request('service_id'),
        ];

        $requests = $this->serviceRequestService->getPendingRequests(
            auth()->user(),
            $filters,
            10
        );

        return response()->json($requests);
    }

    /**
     * Get all requests for authenticated user (any status)
     */
    public function showAllRequests()
    {
        $filters = [
            'status' => request('status'),
            'service_id' => request('service_id'),
        ];

        $requests = $this->serviceRequestService->getAllUserRequests(
            auth()->user(),
            $filters,
            10
        );

        return response()->json($requests);
    }

    /**
     * Create a new service request
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'description' => 'required|string|max:500',
            'address' => 'nullable|string|max:255',
            'lat' => ['nullable', 'numeric', 'between:-90,90'],
            'lng' => ['nullable', 'numeric', 'between:-180,180'],
            'title' => 'required|string|max:255',
            'scheduled_at' => 'nullable|date|after:now',
            'price' => 'required|numeric|min:0',
        ]);

        try {
            $serviceRequest = $this->serviceRequestService->createRequest(auth()->user(), $validated);
            return response()->json($serviceRequest, 201);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    /**
     * Get service request details with pending offers
     */
    public function show($id)
    {
        try {
            $request = $this->serviceRequestService->getRequestDetails($id);
            return response()->json($request);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Service request not found'], 404);
        }
    }

    /**
     * Update a service request
     */
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'description' => 'sometimes|string|max:500',
            'title' => 'sometimes|string|max:255',
            'lat' => 'sometimes|numeric|between:-90,90',
            'lng' => 'sometimes|numeric|between:-180,180',
            'address' => 'sometimes|string',
            'scheduled_at' => 'nullable|date|after:now',
            'price' => 'sometimes|numeric|min:0',
        ]);

        try {
            $serviceRequest = $this->serviceRequestService->updateRequest($id, auth()->user(), $validated);
            return response()->json($serviceRequest);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 403);
        }
    }

    /**
     * Delete a pending service request
     */
    public function destroy($id)
    {
        try {
            $this->serviceRequestService->deleteRequest($id, auth()->user());
            return response()->json(['message' => 'Request deleted successfully']);
        } catch (\Exception $e) {
            return response()->json(
                ['message' => $e->getMessage()],
                in_array($e->getMessage(), ['Unauthorized']) ? 403 : 400
            );
        }
    }

    /**
     * Cancel a pending service request
     */
    public function cancel($id)
    {
        try {
            $request = $this->serviceRequestService->cancelRequest($id, auth()->user());
            return response()->json($request);
        } catch (\Exception $e) {
            return response()->json(
                ['message' => $e->getMessage()],
                in_array($e->getMessage(), ['Unauthorized']) ? 403 : 400
            );
        }
    }

    /**
     * Mark a service request as completed
     */
    public function complete($id)
    {
        try {
            $request = $this->serviceRequestService->completeRequest($id);
            return response()->json($request);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Service request not found'], 404);
        }
    }
}
