part of gogo_routing;

class GoGoRouteHelper {
  String? get nowLocation => _nowLocation;
  String? _nowLocation = GoPages.home;

  void _onLocationChanged(String? location) {
    if (location != null) _nowLocation = location;
    print("location: $location");
  }

  Future<void> push(String route, {Object? extra}) =>
      _goRouter.push(route, extra: extra);

  RouterConfig<RouteMatchList> get routerForInitialize => _goRouter;

  late final GoRouter _goRouter = GoRouter(observers: [
    _NavigatorLocationObserver(helper: this),
  ], routes: [
    GoRoute(
        path: GoPages.home,
        builder: (_, __) => const HomePage(),
        redirect: (context, _) => GoRedirect.redirectAtHome()),
    GoRoute(
        path: GoPages.profileSetting,
        builder: (_, __) => const ProfileSettingPage()),
    GoRoute(path: GoPages.welcome, builder: (_, __) => const WelcomePage()),
    GoRoute(
        path: GoPages.chat(id: _initializeIdKey),
        builder: (_, state) => ChatPage(id: _getId(state))),
    GoRoute(
        path: GoPages.askJoin(id: _initializeIdKey),
        pageBuilder: (_, state) => JoinAskPopUpPage(
            id: _getId(state),
            isLinkInvite:
                _getQueryParams(state, key: 'isLinkInvite') == 'true')),
    GoRoute(
        path: GoPages.needUpdate,
        pageBuilder: (_, state) =>
            NeedUpdatePopUpPage(info: state.extra as AppVersionInfo)),
  ]);

  static String _getId(GoRouterState state) => state.pathParameters[_idKey]!;

  static String? _getQueryParams(GoRouterState state, {required String key}) =>
      state.uri.queryParameters[key];

  static const _idKey = 'id';
  static const _initializeIdKey = ':$_idKey';
}

// --- Private Class ---

class _NavigatorLocationObserver extends NavigatorObserver {
  final GoGoRouteHelper helper;

  _NavigatorLocationObserver({required this.helper});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    helper._onLocationChanged(_routeSettingToPath(route.settings));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      helper._onLocationChanged(_routeSettingToPath(previousRoute.settings));
    }
  }

  String? _routeSettingToPath(RouteSettings settings) {
    final args = settings.arguments as Map<String, String>?;
    final id = args?[GoGoRouteHelper._idKey];
    return settings.name
        ?.replaceAll(GoGoRouteHelper._initializeIdKey, id ?? '');
  }
}
