part of gogo_routing;

class GoRedirect {
  static Future<String?> redirectAtHome() async {
    if (!await _loginCheck()) {
      return GoPages.welcome;
    }

    return null;
  }

  static Future<bool> _loginCheck() async {
    final checkLogin = GetIt.I.get<CheckLoginUseCase>();
    return await checkLogin();
  }
}
