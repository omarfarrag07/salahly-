class ApiConstants {
  // 192.168.1.15
  // 10
  static const String baseUrl = 'http://192.168.1.15:8000/api/';
  static const String baseImageUrl = "http://192.168.1.15:8000/storage/";
  static const String logOutEndPoint = 'logout';
  static const String loginProviderEndPoint = 'token';
  static const String loginUserEndPoint = 'token';
  static const String registerProviderEndPoint = 'register-provider';
  static const String registerUserEndPoint = 'register';
  static const String getCategories = 'categories';
  static const String requestService = 'service-requests';
  static const String getAllRequests = 'requests';
  static sendOffer(int id) => 'request/$id/offer';
  static const String getAcceptedUserOffers = "/accepted-offers";
  static const String getAllPendingUserRequests = "service-requests";
  static const String getAllUserRequests = "all-my-service-requests";
  static String getOffers(int id) => "service-requests/$id";
  static acceptOffer(int id) => "offers/$id/accept";
  static rejectOffer(int id) => "offers/$id/reject";
  static const String getNearbyProviders = "nearby-providers";
  static const String notificationEndPoint = "broadcasting/auth";
  static const String paymentEndPoint = "payments";
  static const String reviewProviderEndPoint = "ratings";
}

class CacheConstants {
  static const String token = "token";
  static const String language = "language";
  static const String latitude = 'lat';
  static const String longitude = 'lng';
}

class UserType {
  static const String user = "user";
  static const String provider = "provider";
}

class ProviderStatus {
  static const String approved = "approved";
  static const String pending = "pending";
  static const String rejected = "rejected";
  static const String suspended = "suspended";
}

class FilterRequestsStatus {
  static const String pending = "pending";
  static const String accepted = "accepted";
  static const String cancelled = "canceled";
  static const String paid = "paid";
  static const String completed = "completed";
}
