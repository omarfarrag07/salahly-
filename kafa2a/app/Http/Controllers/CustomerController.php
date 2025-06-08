<?php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;

class CustomerController extends Controller
{
    public function index()
    {
        // Show all customers (users with type 'Customer')
        $customers = User::where('type', 'Customer')->get();
        return response()->json($customers);
    }

    public function show($id)
    {
        $customer = User::where('type', 'Customer')->findOrFail($id);
        return response()->json($customer);
    }

    public function update(Request $request, $id)
    {
        $customer = User::where('type', 'Customer')->findOrFail($id);
        $customer->update($request->only('name', 'email'));
        return response()->json($customer);
    }

    public function destroy($id)
    {
        $customer = User::where('type', 'Customer')->findOrFail($id);
        $customer->delete();
        return response()->json(['message' => 'Customer deleted']);
    }
}