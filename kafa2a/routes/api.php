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
use App\Models\User;
use Illuminate\Validation\ValidationException;

//////////////////////////////////////////////////////////////////
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\Auth\EmailVerificationNotificationController;
use App\Http\Controllers\Auth\NewPasswordController;
use App\Http\Controllers\Auth\PasswordResetLinkController;
use App\Http\Controllers\Auth\RegisteredUserController;
use App\Http\Controllers\Auth\RegisteredProviderController;
use App\Http\Controllers\Auth\VerifyEmailController;
// use Illuminate\Support\Facades\Route;

Route::post('/register', [RegisteredUserController::class, 'store'])
    ->middleware('guest')
    ->name('register');

Route::post('/register-provider', [RegisteredProviderController::class, 'store'])
    ->middleware('guest')
    ->name('register-provider');

// Route::post('/login', [AuthenticatedSessionController::class, 'store'])
//     ->middleware('guest')
//     ->name('login');

Route::post('/forgot-password', [PasswordResetLinkController::class, 'store'])
    ->middleware('guest')
    ->name('password.email');

Route::post('/reset-password', [NewPasswordController::class, 'store'])
    ->middleware('guest')
    ->name('password.store');

Route::get('/verify-email/{id}/{hash}', VerifyEmailController::class)
    ->middleware(['auth', 'signed', 'throttle:6,1'])
    ->name('verification.verify');

Route::post('/email/verification-notification', [EmailVerificationNotificationController::class, 'store'])
    ->middleware(['auth', 'throttle:6,1'])
    ->name('verification.send');

// Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
//     ->middleware('auth')
//     ->name('logout');

////////////////////////////////////////////////////////////////////////////////////////////////







Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', function (Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out'], 200);
    });

    Route::apiResource('users', UserController::class)->only(['index', 'show', 'update', 'destroy']);
    Route::apiResource('providers', ProviderController::class)->only(['index', 'show', 'update', 'destroy']);


    // Service Requests
    Route::apiResource('service-requests', ServiceRequestController::class);
    Route::post('service-requests/{request}/accept', [ServiceRequestController::class, 'accept']);
    Route::post('service-requests/{request}/cancel', [ServiceRequestController::class, 'cancel']);
    Route::post('service-requests/{request}/complete', [ServiceRequestController::class, 'complete']);

    // Offers
    Route::apiResource('offers', OfferController::class)->only(['index', 'store', 'show']);
    Route::post('offers/{id}/accept', [OfferController::class, 'accept']);
    Route::post('offers/{id}/reject', [OfferController::class, 'reject']);
    Route::get('my-request-offers', [OfferController::class, 'offersForMyRequests']);

    // Categories
    Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);
    Route::middleware('admin')->group(function () {
        Route::post('categories', [CategoryController::class, 'store']);
        Route::put('categories/{id}', [CategoryController::class, 'update']);
        Route::delete('categories/{id}', [CategoryController::class, 'destroy']);
    });


    // Broadcast::channel('chat.{receiverId}', function ($user, $receiverId) {
    //     return (int) $user->id === (int) $receiverId;
    // });

    // Route::apiResource('services', ServiceController::class);



    Route::apiResource('ratings', RatingController::class)->only(['index', 'store']);
    Route::apiResource('messages', MessageController::class)->only(['index', 'store']);

    // Admin Routes
    Route::prefix('admin')->middleware('admin')->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard']);
        Route::get('/users', [AdminController::class, 'allUsers']);
        Route::get('/providers', [AdminController::class, 'allProviders']);
        Route::get('/requests', [AdminController::class, 'allRequests']);
        Route::delete('/users/{id}', [AdminController::class, 'deleteUser']);
    });

    // Accepted Offers
    Route::apiResource('accepted-offers', \App\Http\Controllers\AcceptedOfferController::class)->only(['index', 'show', 'store', 'update', 'destroy']);
    Route::get('service-requests/{requestId}/accepted-offer', [\App\Http\Controllers\AcceptedOfferController::class, 'showByRequest']);
    Route::get('users/{userId}/accepted-offers', [\App\Http\Controllers\AcceptedOfferController::class, 'acceptedOfferforUser']);
});


// Login
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

