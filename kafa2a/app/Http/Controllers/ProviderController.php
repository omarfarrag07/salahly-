<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class ProviderController extends Controller
{
    public function index()
    {
        $providers = User::where('type', 'Provider')->with(['offers', 'ratings'])->get();
        return response()->json($providers);
    }

    public function show($id)
    {
        $provider = User::where('type', 'Provider')->with(['offers', 'ratings'])->findOrFail($id);
        return response()->json($provider);
    }

    public function update(Request $request, $id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
        $provider->update($request->only('name', 'email', 'phone'));
        return response()->json($provider);
    }

    public function destroy($id)
    {
        $provider = User::where('type', 'Provider')->findOrFail($id);
        $provider->delete();
        return response()->json(['message' => 'Provider deleted']);
    }
}
