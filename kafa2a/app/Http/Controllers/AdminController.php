namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\ServiceRequest;

class AdminController extends Controller
{
    public function dashboard()
    {
        return view('admin.dashboard', [
            'usersCount' => User::where('type', 'User')->count(),
            'providersCount' => User::where('type', 'Provider')->count(),
            'requestsCount' => ServiceRequest::count(),
        ]);
    }

    public function users()
    {
        $users = User::where('type', 'User')->get();
        return view('admin.users', compact('users'));
    }

    public function providers()
    {
        $providers = User::where('type', 'Provider')->get();
        return view('admin.providers', compact('providers'));
    }

    public function requests()
    {
        $requests = ServiceRequest::with(['user', 'service'])->get();
        return view('admin.requests', compact('requests'));
    }
}
