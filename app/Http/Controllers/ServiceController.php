<?php
namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    public function index()
    {
        // Return all services 
        $lang = request()->header('Accept-Language', 'en');
        $services = Service::all()->map(function ($service) use ($lang) {
            return [
                'id' => $service->id,
                'name' => $lang === 'ar' ? $service->name_ar : $service->name_en,
                'description' => $lang === 'ar' ? $service->description_ar : $service->description_en,
            ];
        });
        return response()->json($services);
    }

    public function store(Request $request)
    {
        // Validate and create a new service
        $validated = $request->validate([
            'name_en' => 'required|string|max:255',
            'name_ar' => 'required|string|max:255',
            'description_en' => 'required|string',
            'description_ar' => 'required|string',
            'category_id' => 'required|exists:categories,id',
        ]);
        $service = Service::create($validated);
        return response()->json($service, 201);
    }

    public function show($id)
    {
        $lang = request()->header('Accept-Language', 'en');
        $service = Service::findOrFail($id);

        return response()->json([
            'id' => $service->id,
            'name' => $lang === 'ar' ? $service->name_ar : $service->name_en,
            'description' => $lang === 'ar' ? $service->description_ar : $service->description_en,
            'category_id' => $service->category_id,
            // add other fields as needed
        ]);
    }
    public function update(Request $request, $id)
    {
        // Find and update a specific service
        $service = Service::findOrFail($id);
        $validated = $request->validate([
            'name_en' => 'required|string|max:255',
            'name_ar' => 'required|string|max:255',
            'description_en' => 'required|string',
            'description_ar' => 'required|string',
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
