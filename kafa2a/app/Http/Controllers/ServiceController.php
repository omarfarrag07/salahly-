<?php
namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    public function index()
    {
        // Return all services 
        return response()->json(Service::all());
    }

    public function store(Request $request)
    {
        // Validate and create a new service
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
        ]);
        $service = Service::create($validated);
        return response()->json($service, 201);
    }

    public function show($id)
    {
        // Return a specific service 
        $service = Service::findOrFail($id); 
        return response()->json($service);
    }

    public function update(Request $request, $id)
    {
        // Find and update a specific service
        $service = Service::findOrFail($id);
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
        ]);
        $service->update($validated);
        return response()->json($service);
    }

    public function destroy($id)
    {
        // Delete the specific service
        $service = Service::findOrFail($id);
        $service->delete();
        return response()->json(['message' => 'Service deleted successfully']);
    }
}
