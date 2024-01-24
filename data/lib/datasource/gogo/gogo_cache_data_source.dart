import 'package:gogo_mvp_data/datastore/gogo_cache_store.dart';
import 'package:gogo_mvp_data/types/types.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';

class GogoCacheDataSource {
  final GoCacheStore _cacheStore;

  GogoCacheDataSource(this._cacheStore);

  void cacheUser(User user) {
    _cacheStore.cacheUser(user);
  }

  void cacheUserAll(Iterable<User> userList) {
    userList.forEach(cacheUser);
  }

  User? getUser(String userId) {
    return _cacheStore.getUser(userId);
  }

  UserMap getUserMap() {
    return _cacheStore.cachedUserMap;
  }

  Future<UserMap> getUserMapWithCaching({
    required Set<String> needUserIdSet,
    required Future<Iterable<User>> Function(Iterable<String> idList)
        getUsersByIdAtRemote,
  }) async {
    final nonCachedUserIds = findNonCachedUserIds(needUserIdSet);
    if (nonCachedUserIds.isEmpty) return getUserMap();

    final nonCachedUsersResult = await getUsersByIdAtRemote(nonCachedUserIds);
    cacheUserAll(nonCachedUsersResult);
    return getUserMap();
  }

  Iterable<String> findNonCachedUserIds(Iterable<String> userIds) {
    return userIds.where((userId) => !getUserMap().containsKey(userId));
  }
}
