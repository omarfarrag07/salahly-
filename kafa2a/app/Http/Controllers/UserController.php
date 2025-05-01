<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\User;

class UserController extends Controller
{
    public function index()
    {
        // Show all users who are NOT providers or admins
        $users = User::where('type', 'User')->get();
        return response()->json($users);
    }

    public function show($id)
    {
        $user = User::where('type', 'User')->findOrFail($id);
        return response()->json($user);
    }

    public function update(Request $request, $id)
    {
        $user = User::where('type', 'User')->findOrFail($id);
        $user->update($request->only('name', 'email'));
        return response()->json($user);
    }

    public function destroy($id)
    {
        $user = User::where('type', 'User')->findOrFail($id);
        $user->delete();
        return response()->json(['message' => 'User deleted']);
    }
}
