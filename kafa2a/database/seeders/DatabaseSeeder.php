<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Service;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Example user
        // User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);

        // Categories and related services
        $categories = [
            'Cleaning' => ['Home Cleaning', 'Office Cleaning'],
            'Plumbing' => ['Leak Repair', 'Pipe Installation'],
            'Electrical' => ['Wiring', 'Light Installation'],
        ];

        foreach ($categories as $catName => $services) {
            $category = Category::create(['name' => $catName]);
            foreach ($services as $serviceName) {
                Service::create([
                    'name' => $serviceName,
                    'category_id' => $category->id,
                ]);
            }
        }
    }
}
