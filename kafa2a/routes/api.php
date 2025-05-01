<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ServiceRequestController;
use App\Http\Controllers\OfferController;
use App\Http\Controllers\RatingController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProviderController;

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('users', UserController::class)->only(['index', 'show', 'update', 'destroy']);
    Route::apiResource('providers', ProviderController::class)->only(['index', 'show', 'update', 'destroy']);



    Route::apiResource('service-requests', ServiceRequestController::class);
    Route::post('service-requests/{request}/accept', [ServiceRequestController::class, 'accept']);
    Route::post('service-requests/{request}/cancel', [ServiceRequestController::class, 'cancel']);
    Route::post('service-requests/{request}/complete', [ServiceRequestController::class, 'complete']);

    Route::apiResource('offers', OfferController::class)->only(['index', 'store', 'show']);
    Route::post('offers/{id}/accept', [OfferController::class, 'accept']);
    Route::post('offers/{id}/reject', [OfferController::class, 'reject']);

    Route::apiResource('ratings', RatingController::class)->only(['index', 'store']);
    Route::apiResource('messages', MessageController::class)->only(['index', 'store']);

    Route::prefix('admin')->middleware('admin')->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard']);
        Route::get('/users', [AdminController::class, 'allUsers']);
        Route::get('/providers', [AdminController::class, 'allProviders']);
        Route::get('/requests', [AdminController::class, 'allRequests']);
        Route::delete('/users/{id}', [AdminController::class, 'deleteUser']);
    });
});
