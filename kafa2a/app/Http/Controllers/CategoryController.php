<?php
namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    // GET /api/categories
    public function index()
    {
        $lang = request()->header('Accept-Language', 'en');
        $categories = Category::with('services')->get();

        $localized = $categories->map(function ($category) use ($lang) {
            return [
                'id' => $category->id,
                'name' => $lang === 'ar' ? $category->name_ar : $category->name_en,
                'services' => $category->services->map(function ($service) use ($lang) {
                    return [
                        'id' => $service->id,
                        'name' => $lang === 'ar' ? $service->name_ar : $service->name_en,
                        'description' => $lang === 'ar' ? $service->description_ar : $service->description_en,
                        'category_id' => $service->category_id,
                    ];
                }),
            ];
        });

        return response()->json($localized);
    }

    // POST /api/categories
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name_ar' => 'required|string|max:255',
            'name_en' => 'required|string|max:255',
        ]);

        $category = Category::create($validated);
        return response()->json($category, 201);
    }

    // GET /api/categories/{id}
    public function show($id)
    {
        $lang = request()->header('Accept-Language', 'en');
        $category = Category::with('services')->findOrFail($id);

        $localized = [
            'id' => $category->id,
            'name' => $lang === 'ar' ? $category->name_ar : $category->name_en,
            'services' => $category->services->map(function ($service) use ($lang) {
                return [
                    'id' => $service->id,
                    'name' => $lang === 'ar' ? $service->name_ar : $service->name_en,
                    'description' => $lang === 'ar' ? $service->description_ar : $service->description_en,
                    'category_id' => $service->category_id,
                ];
            }),
        ];

        return response()->json($localized);
    }

    // PUT /api/categories/{id}
    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $validated = $request->validate([
            'name_ar' => 'required|string|max:255',
            'name_en' => 'required|string|max:255',
        ]);

        $category->update($validated);
        return response()->json($category);
    }

    // DELETE /api/categories/{id}
    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        $category->delete();
        return response()->json(['message' => 'Category deleted']);
    }
}
