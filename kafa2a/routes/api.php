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
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\PaymentController;
use App\Models\AcceptedOffer;


use App\Models\User;
use Illuminate\Validation\ValidationException;

// Auth Controllers
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\EmailVerificationNotificationController;
use App\Http\Controllers\Auth\NewPasswordController;
use App\Http\Controllers\Auth\PasswordResetLinkController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\Auth\RegisteredProviderController;
use App\Http\Controllers\Auth\VerifyEmailController;

//////////////////////////////////////////////////////////////////
// Public Authentication & Password Routes
//////////////////////////////////////////////////////////////////

Route::post('/register', [RegisteredUserController::class, 'store'])
    ->middleware('guest')->name('register');

Route::post('/register-provider', [RegisteredProviderController::class, 'store'])
    ->middleware('guest')->name('register-provider');

// Route::post('/login', [AuthenticatedSessionController::class, 'store'])
//     ->middleware('guest')->name('login');

Route::post('/forgot-password', [PasswordResetLinkController::class, 'store'])
    ->middleware('guest')->name('password.email');

Route::post('/reset-password', [NewPasswordController::class, 'store'])
    ->middleware('guest')->name('password.store');

Route::get('/verify-email/{id}/{hash}', VerifyEmailController::class)
    ->middleware(['auth', 'signed', 'throttle:6,1'])->name('verification.verify');

Route::post('/email/verification-notification', [EmailVerificationNotificationController::class, 'store'])
    ->middleware(['auth', 'throttle:6,1'])->name('verification.send');

// Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
//     ->middleware('auth')->name('logout');

//////////////////////////////////////////////////////////////////
// Protected API Routes (auth:sanctum)
//////////////////////////////////////////////////////////////////

Route::middleware('auth:sanctum')->group(function () {

    // Logout
    Route::post('/logout', function (Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out'], 200);
    });

    // Users & Providers
    Route::apiResource('users', UserController::class)->only(['index', 'show', 'update', 'destroy']);
    Route::apiResource('providers', ProviderController::class)->only(['index', 'show', 'update', 'destroy']);

    // Service Requests
    Route::apiResource('service-requests', ServiceRequestController::class);
    Route::get('all-my-service-requests', [ServiceRequestController::class, 'showAllRequests']);
    // Route::post('service-requests/{request}/accept', [ServiceRequestController::class, 'accept']);
    Route::post('service-requests/{id}/cancel', [ServiceRequestController::class, 'cancel']);
    Route::post('service-requests/{id}/complete', [ServiceRequestController::class, 'complete']);

    // Offers
    Route::apiResource('offers', OfferController::class)->only(['index', 'store', 'show']);
    Route::post('offers/{id}/accept', [OfferController::class, 'accept']);
    Route::post('offers/{id}/reject', [OfferController::class, 'reject']);
    Route::get('my-request-offers', [OfferController::class, 'offersForMyRequests']);


    // Route::middleware('admin')->group(function () {



    //     Route::get('/dashboard', [AdminController::class, 'dashboard']);
    //     Route::get('/users', [AdminController::class, 'allUsers']);
    //     Route::get('/providers', [AdminController::class, 'allProviders']);
    //     Route::get('/requests', [AdminController::class, 'allRequests']);
    //     Route::delete('/users/{id}', [AdminController::class, 'deleteUser']);

    //     Route::post('/provider/{userId}/review', [AdminController::class, 'reviewProviderStatus']);
    // });

    // Ratings & Messages
    Route::apiResource('ratings', RatingController::class)->only(['index', 'store']);
    Route::apiResource('messages', MessageController::class)->only(['index', 'store']);

    // Admin Routes
    // Route::prefix('admin')->middleware(['auth', 'admin'])->group(function () {
    //     Route::get('/dashboard', [AdminController::class, 'dashboard']);
    //     Route::get('/users', [AdminController::class, 'allUsers']);
    //     Route::get('/providers', [AdminController::class, 'allProviders']);
    //     Route::get('/requests', [AdminController::class, 'allRequests']);
    //     Route::delete('/users/{id}', [AdminController::class, 'deleteUser']);
    // });


    // Provider specific routes
    Route::apiResource('provider', ProviderController::class);
    Route::get('/requests', [ProviderController::class, 'getAllRequests']);         // Get all service requests
    Route::get('/requests/{id}', [ProviderController::class, 'getRequestByID']);   // view request by id
    Route::post('/request/{id}/offer', [ProviderController::class, 'sendOffer']); // send an offer

    // Accepted Offers
    Route::apiResource('accepted-offers', \App\Http\Controllers\AcceptedOfferController::class)
        ->only(['index', 'show', 'store', 'update', 'destroy']);
    Route::get('service-requests/{requestId}/accepted-offer', [\App\Http\Controllers\AcceptedOfferController::class, 'showByRequest']);
    Route::get('users/{userId}/accepted-offers', [\App\Http\Controllers\AcceptedOfferController::class, 'acceptedOfferforUser']);

    // // Example for future: Broadcast/Chat
    // Broadcast::channel('chat.{receiverId}', function ($user, $receiverId) {
    //     return (int) $user->id === (int) $receiverId;
    // });

    // // Example for future: Services
    // Route::apiResource('services', ServiceController::class);
    Route::prefix('ratings')->group(function () {
        Route::post('/', [RatingController::class, 'store']);


    });

    // 1. Get a list of nearby providers by coordinates (POST recommended for body params)
    Route::post('/nearby-providers', [\App\Http\Controllers\LocationController::class, 'getNearbyProviders']);

    // 2. Get the nearest provider for a specific service request (by id)
    Route::get('/service-requests/{id}/nearest-provider', [\App\Http\Controllers\LocationController::class, 'nearestProvider']);

    // 3. Get a list of nearest providers for a specific service request (by id)
    Route::get('/service-requests/{id}/nearest-providers', [\App\Http\Controllers\LocationController::class, 'nearestProvidersToServiceRequest']);
});



// Categories
Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);
Route::get('/Categories', [CategoryController::class, 'getAllCategories']);


//admin routes
//tested

//AdminController routes (User & Provider Management)
Route::get('/Users', [AdminController::class, 'getAllUsers']);
Route::get('/Users/{id}', [AdminController::class, 'getUserById']);
Route::delete('/Users/{id}', [AdminController::class, 'deleteUser']);
Route::get('/users-count', [AdminController::class, 'countOfUsers']);

Route::get('/Providers', [AdminController::class, 'getAllProviders']);
Route::get('/Providers/{id}', [AdminController::class, 'getProviderById']);
Route::put('/Providers/{userId}/review', [AdminController::class, 'reviewProviderStatus']);
Route::get('/providers-count', [AdminController::class, 'countOfProviders']);
Route::get('/Providers-pending', [AdminController::class, 'getPendingProviders']);
Route::post('/providers', [AdminController::class, 'createProvider']);
Route::get('/ApprovedSuspendedProviders', [AdminController::class, 'getApprovedSuspendedProviders']);


// Dashboard
Route::get('/dashboard', [AdminController::class, 'dashboard']);

//admin profile
Route::get('/profile', [AdminController::class, 'AdminProfile']);

// Requests
Route::get('/Requests', [AdminController::class, 'getAllServiceRequests']);
Route::get('/Requests/{id}', [AdminController::class, 'getServiceRequestById']);

//  Offers
Route::get('/offers', [AdminController::class, 'getAllOffers']);

// Category Routes
Route::prefix('categories')->group(function () {
    Route::get('/', [CategoryController::class, 'index']);
    Route::get('/{id}', [CategoryController::class, 'show']);
    Route::post('/', [CategoryController::class, 'store']);
    Route::put('/{id}', [CategoryController::class, 'update']);
    Route::delete('/{id}', [CategoryController::class, 'destroy']);
});

//  Service Routes
Route::prefix('services')->group(function () {
    Route::get('/', [ServiceController::class, 'index']);
    Route::get('/{id}', [ServiceController::class, 'show']);
    Route::post('/', [ServiceController::class, 'store']);
    Route::put('/{id}', [ServiceController::class, 'update']);
    Route::delete('/{id}', [ServiceController::class, 'destroy']);
});

//payment routes

Route::prefix('payments')->group(function () {
    Route::get('/', [PaymentController::class, 'index']);          // Get all payments (admin or history)
    Route::get('/{id}', [PaymentController::class, 'show']);       // Get a specific payment by ID
    Route::post('/', [PaymentController::class, 'store']);         // Create a new payment (dummy, cash, etc.)
    Route::delete('/{id}', [PaymentController::class, 'destroy']); // Delete a payment by ID (admin only)

    Route::get('/success', [PaymentController::class, 'success']); // Payment success callback (for gateways)
    Route::get('/cancel', [PaymentController::class, 'cancel']);   // Payment cancel callback (for gateways)
});

Route::prefix('ratings')->group(
    function () {

        Route::get('/{id}/rating-reviews', [RatingController::class, 'getProviderRatingAndReviews']);

    }
);
// Route::prefix('ratings')->group(function () {
//     Route::get('/', [RatingController::class, 'index']);          // List all ratings
//     Route::post('/', [RatingController::class, 'store']);         // Create a new rating
//     Route::get('/{id}', [RatingController::class, 'show']);       // Show a specific rating by ID
//     Route::put('/{id}', [RatingController::class, 'update']);     // Update a specific rating by ID
//     Route::delete('/{id}', [RatingController::class, 'destroy']); // Delete a specific rating by ID

// }
// );









//////////////////////////////////////////////////////////////////
// Token Login Route (API only)
//////////////////////////////////////////////////////////////////

Route::post('/token', function (Request $request) {
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    $user = User::where('email', $request->email)->first();

    if (!$user || !Hash::check($request->password, $user->password)) {
        throw ValidationException::withMessages([
            'email' => ['The provided credentials are incorrect.'],
        ]);
    }

    return response()->json([
        'token' => $user->createToken('api-token')->plainTextToken,
        'user' => $user,
    ]);
});

