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
        'service' => ['required', 'string', 'max:255'],
        'national_id' => ['required', 'string', 'max:255'],
        'address' => ['required', 'string', 'max:255'],
        'police_certificate' => ['required', 'file', 'mimes:pdf,jpg,jpeg,png', 'max:2048'],
        'selfie' => ['required', 'file', 'mimes:pdf,jpg,jpeg,png', 'max:2048'],
        'gender' => ['required', 'in:M,F'],
    ]);

    $policePath = $request->file('police_certificate')->store('certificates', 'public');
    $selfiePath = $request->file('selfie')->store('selfies', 'public');

    $provider = Provider::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => Hash::make($request->password),
        'service' => $request->service,
        'national_id' => $request->national_id,
        'address' => $request->address,
        'gender' => $request->gender,
        'police_certificate_path' => $policePath,
        'selfie_path' => $selfiePath,
    ]);

    event(new Registered($provider));
    
    // Auth::login($provider);

    return response()->json($provider, 201);
}
}


