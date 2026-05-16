abstract class AuthLocalDataSource {
  void saveToken(String token);

  String getToken();

  void removeToken();
}
