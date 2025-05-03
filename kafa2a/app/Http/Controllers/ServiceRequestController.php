<?php

namespace App\Http\Controllers;

use App\Models\AcceptedOffer;
use App\Models\ServiceRequest;
use Illuminate\Http\Request;

class ServiceRequestController extends Controller
{
    public function index()
    {
        $requests = ServiceRequest::with(['service', 'user'])
            ->when(request('status'), fn($q, $status) => $q->where('status', $status))
            ->when(request('service_id'), fn($q, $id) => $q->where('service_id', $id))
            ->latest()
            ->paginate(10);

        return response()->json($requests);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'description' => 'required|string|max:500',
            'location' => 'required|json',
            'scheduled_at' => 'nullable|date|after:now'
        ]);

        $serviceRequest = auth()->user()->serviceRequests()->create([
            ...$validated,
            'status' => 'pending',
        ]);

        return response()->json($serviceRequest, 201);
    }

    public function show($id)
    {
        $request = ServiceRequest::with(['user', 'service', 'offers'])->findOrFail($id);
        return response()->json($request);
    }

    public function update(Request $request, $id)
    {
        $serviceRequest = ServiceRequest::findOrFail($id);

        if ($serviceRequest->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'description' => 'sometimes|string|max:500',
            'location' => 'sometimes|json',
            'scheduled_at' => 'nullable|date|after:now'
        ]);

        $serviceRequest->update($validated);

        return response()->json($serviceRequest);
    }

    public function destroy($id)
    {
        $request = ServiceRequest::findOrFail($id);

        if ($request->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($request->status !== 'pending') {
            return response()->json(['message' => 'Only pending requests can be deleted'], 400);
        }

        $request->delete();

        return response()->json(['message' => 'Request deleted successfully']);
    }

    public function accept(ServiceRequest $request)
    {
        $request->update(['status' => 'accepted']);

        AcceptedOffer::create([
            'service_request_id' => $request->id,
            'provider_id' => auth()->id(), 
        ]);
        //ToDo: Notify the user about the acceptance
        // event(new RequestAccepted($request)); // you can define this event similarly

        // return response()->json(['message' => 'Request accepted']);

        return response()->json($request);
    }

    public function cancel(ServiceRequest $request)
    {
        abort_if($request->user_id !== auth()->id(), 403);
        abort_if($request->status !== 'pending', 400, 'Only pending requests can be canceled');
        $request->update(['status' => 'canceled']);
        return response()->json($request);
    }

    public function complete(ServiceRequest $request)
    {
        $request->update(['status' => 'completed']);
        return response()->json($request);
    }
}
