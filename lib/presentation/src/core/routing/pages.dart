part of gogo_routing;

class GoPages {
  static const String home = '/'; // if un-auth: redirect
  static const String _askJoin = '/ask_join'; // req-id(chat-id)
  static const String welcome = '/welcome'; // if authed: redirect
  static const String profileSetting =
      '/profile_setting'; // initial check (auth)
  static const String _chat = '/chat'; // req-id(chat-id)
  static const String needUpdate = '/need_update';

  static String askJoin({required String id, bool? isLinkInvite}) =>
      '$_askJoin/$id${isLinkInvite == true ? '?isLinkInvite=true' : ''}';

  static String chat({required String id}) => '$_chat/$id';

  GoPages._();
}
