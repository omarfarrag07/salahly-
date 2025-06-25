<?php

namespace Database\Seeders;

use Illuminate\Support\Facades\Hash;


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
        User::updateOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Super Admin',
                'email' => 'admin@example.com',
                'password' => Hash::make('password123'), 
                'type' => 'admin',
                'phone' => '1234567890',
                'address' => 'Admin HQ',
                'status' => 'accepted',
                'email_verified_at' => now(),
            ]
        );
    }
    // public function run(): void
    // {
    //     // Example user
    //     // User::factory()->create([
    //     //     'name' => 'Test User',
    //     //     'email' => 'test@example.com',
    //     // ]);

    //     // Categories and related services
    //     $categories = [
    //         'Cleaning' => ['Home Cleaning', 'Office Cleaning'],
    //         'Plumbing' => ['Leak Repair', 'Pipe Installation'],
    //         'Electrical' => ['Wiring', 'Light Installation'],
    //         'others' => ['others']
    //     ];

    //     foreach ($categories as $catName => $services) {
    //         $category = Category::create(['name' => $catName]);
    //         foreach ($services as $serviceName) {
    //             Service::create([
    //                 'name' => $serviceName,
    //                 'category_id' => $category->id,
    //             ]);
    //         }
    //     }
    // }
}
