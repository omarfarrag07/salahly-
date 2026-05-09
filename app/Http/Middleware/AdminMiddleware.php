<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        // $type = strtolower($request->user()?->type ?? '');
        // print($type);
        if (auth()->check() && auth()->user()->type === 'Admin') {
            return $next($request);
        }
        return response()->json(['error' => 'Unauthorized. Admins only.'], 403);
    }
}
