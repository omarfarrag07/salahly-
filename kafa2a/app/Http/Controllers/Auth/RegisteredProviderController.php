<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Provider;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;


use Illuminate\Support\Facades\Storage;

class RegisteredProviderController extends Controller
{
    /**
     * Handle an incoming registration request.
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'lowercase', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
            'service_id' => 'required|exists:services,id',
            'national_id' => 'required|string|max:20|unique:users,national_id',
            'address' => ['required', 'string', 'max:255'],
            'lat' => ['nullable', 'numeric', 'between:-90,90'],
            'lng' => ['nullable', 'numeric', 'between:-180,180'],
            'police_certificate' => ['required', 'file', 'mimes:pdf,jpg,jpeg,png', 'max:5120'],
            'selfie' => ['required', 'file', 'mimes:pdf,jpg,jpeg,png', 'max:5120'],
            'phone' => ['required', 'string', 'max:20', 'unique:users,phone'],
            // 'gender' => ['required', 'in:M,F'],
        ]);

        $policePath = $request->file('police_certificate')->store('certificates', 'public');
        $selfiePath = $request->file('selfie')->store('selfies', 'public');

        $provider = Provider::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'service_id' => $request->service_id,
            'national_id' => $request->national_id,
            'address' => $request->address,
            'lat' => $request->lat ?? null, // Optional
            'lng' => $request->lng ?? null, // Optional
            'phone' => $request->phone,
            // 'gender' => $request->gender,
            'police_certificate_path' => $policePath,
            'selfie_path' => $selfiePath,
        ]);

        $provider->refresh();

        event(new Registered($provider));

        // Automatically log in the provider
        Auth::login($provider);

        // Return token for API usage
        $token = $provider->createToken('api-token')->plainTextToken;

        return response()->json([
            'user' => $provider,
            'token' => $token,
        ], 201);
    }

    
}


