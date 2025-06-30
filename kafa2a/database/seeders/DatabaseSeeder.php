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
                'email_verified_at' => now(),
            ]
        );

        // Categories and related services with Arabic and English
        $categories = [
            [
                'name_en' => 'Cleaning',
                'name_ar' => 'تنظيف',
                // 'description_en' => 'Cleaning services for home and office',
                // 'description_ar' => 'خدمات التنظيف للمنازل والمكاتب',
                'services' => [
                    [
                        'name_en' => 'Home Cleaning',
                        'name_ar' => 'تنظيف المنازل',
                        'description_en' => 'General home cleaning',
                        'description_ar' => 'تنظيف عام للمنازل',
                    ],
                    [
                        'name_en' => 'Office Cleaning',
                        'name_ar' => 'تنظيف المكاتب',
                        'description_en' => 'Professional office cleaning',
                        'description_ar' => 'تنظيف احترافي للمكاتب',
                    ],
                ]
            ],
            [
                'name_en' => 'Plumbing',
                'name_ar' => 'سباكة',
                // 'description_en' => 'All plumbing services',
                // 'description_ar' => 'جميع خدمات السباكة',
                'services' => [
                    [
                        'name_en' => 'Leak Repair',
                        'name_ar' => 'إصلاح التسربات',
                        'description_en' => 'Fixing water leaks',
                        'description_ar' => 'إصلاح تسربات المياه',
                    ],
                    [
                        'name_en' => 'Pipe Installation',
                        'name_ar' => 'تركيب الأنابيب',
                        'description_en' => 'Installing new pipes',
                        'description_ar' => 'تركيب أنابيب جديدة',
                    ],
                ]
            ],
            [
                'name_en' => 'Electrical',
                'name_ar' => 'كهرباء',
                // 'description_en' => 'Electrical installation and repair',
                // 'description_ar' => 'تركيب وصيانة الكهرباء',
                'services' => [
                    [
                        'name_en' => 'Wiring',
                        'name_ar' => 'تمديدات كهربائية',
                        'description_en' => 'House wiring services',
                        'description_ar' => 'خدمات تمديدات كهربائية للمنازل',
                    ],
                    [
                        'name_en' => 'Light Installation',
                        'name_ar' => 'تركيب الإضاءة',
                        'description_en' => 'Installing lighting fixtures',
                        'description_ar' => 'تركيب وحدات الإضاءة',
                    ],
                ]
            ],
            [
                'name_en' => 'Painting',
                'name_ar' => 'دهانات',
                // 'description_en' => 'Painting and wall finishing',
                // 'description_ar' => 'خدمات الدهانات والتشطيبات',
                'services' => [
                    [
                        'name_en' => 'Interior Painting',
                        'name_ar' => 'دهان داخلي',
                        'description_en' => 'Painting inside the house',
                        'description_ar' => 'دهان داخل المنزل',
                    ],
                    [
                        'name_en' => 'Exterior Painting',
                        'name_ar' => 'دهان خارجي',
                        'description_en' => 'Painting outside the house',
                        'description_ar' => 'دهان خارج المنزل',
                    ],
                ]
            ],
            [
                'name_en' => 'Others',
                'name_ar' => 'أخرى',
                // 'description_en' => 'Other services',
                // 'description_ar' => 'خدمات أخرى',
                'services' => [
                    [
                        'name_en' => 'Others',
                        'name_ar' => 'أخرى',
                        'description_en' => 'Other services',
                        'description_ar' => 'خدمات أخرى',
                    ],
                ]
            ],
        ];

        foreach ($categories as $cat) {
            $category = Category::create([
                'name_en' => $cat['name_en'],
                'name_ar' => $cat['name_ar'],
                // 'description_en' => $cat['description_en'],
                // 'description_ar' => $cat['description_ar'],
            ]);
            foreach ($cat['services'] as $service) {
                Service::create([
                    'name_en' => $service['name_en'],
                    'name_ar' => $service['name_ar'],
                    'description_en' => $service['description_en'],
                    'description_ar' => $service['description_ar'],
                    'category_id' => $category->id,
                ]);
            }
        }
    }


    }
    // public function run(): void
    // {
    //     // Example user
    //     // User::factory()->create([
    //     //     'name' => 'Test User',
    //     //     'email' => 'test@example.com',
    //     // ]);





