import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';

class MemberRemoteDataSource {
  final FirebaseFirestore _firestore;

  MemberRemoteDataSource(this._firestore);

  CollectionReference get _userDB => _firestore.collection("users");

  Future<User?> getUserInfo(String uid) async {
    final snapshot = await _userDB.doc(uid).get();
    try {
      return snapshot.exists ? User.fromJson(snapshot.data()!) : null;
    } catch (e) {
      return null;
    }
  }

  Future<Iterable<User>> getMultipleUserInfo(Iterable<String> uidList) async {
    if (uidList.isEmpty) return [];

    Future<Iterable<User>> innerGetMultipleUserInfo(Iterable<String> uidList)async {
      final snapshotList = await _userDB.where("id", whereIn: uidList).get(); // maximum request : 30
      return snapshotList.docs.map((snapshot) => User.fromJson(snapshot.data()));
    }

    final chunkList = _splitList(uidList.toList(), 30);
    final snapshotList = await Future.wait(chunkList.map(innerGetMultipleUserInfo));
    return snapshotList.expand((element) => element);
  }

  List<List<T>> _splitList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}

