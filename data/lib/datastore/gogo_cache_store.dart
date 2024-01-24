import 'package:gogo_mvp_domain/entity/user/user.dart';

class GoCacheStore {
  final _cachedUserMap = <String, User>{};

  Map<String, User> get cachedUserMap => _cachedUserMap;

  User? getUser(String userId) => _cachedUserMap[userId];

  void cacheUser(User user) {
    _cachedUserMap[user.id] = user;
  }
}
