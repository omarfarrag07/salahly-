<?php

use Illuminate\Support\Facades\Broadcast;

Route::get('/', function () {
    return ['Laravel' => app()->version()];
});

// ✅ Enable broadcasting authentication routes
Broadcast::routes();

// Route::middleware(['auth', 'admin'])->group(function () {
//     Route::get('/admin/dashboard', [AdminController::class, 'index'])->name('admin.dashboard');
//     // Add more admin-only routes here
// });

Route::get('/test-event', function() {
    return view('test-event');
});

require __DIR__.'/auth.php';
