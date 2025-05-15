<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;

Route::get('/', function () {
    return ['Laravel' => app()->version()];
});

Route::middleware(['auth', 'admin'])->group(function () {
    Route::get('/admin/dashboard', [AdminController::class, 'index'])->name('admin.dashboard');
    // Add more admin-only routes here
});




Route::get('/test-event', function() {
    return view('test-event');
});


require __DIR__.'/auth.php';
