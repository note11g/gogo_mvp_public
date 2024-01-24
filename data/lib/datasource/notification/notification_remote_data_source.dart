import 'package:firebase_database/firebase_database.dart';

class NotificationRemoteDataSource {
  final FirebaseDatabase _firebaseDatabase;

  NotificationRemoteDataSource(this._firebaseDatabase);

  DatabaseReference get _tokenDB => _firebaseDatabase.ref('user_tokens');

  Future<bool> updateFcmToken({
    required String uid,
    required String token,
    required String? oldToken,
  }) async {
    final userTokenRef = _tokenDB.child(uid);
    await userTokenRef.child(token).set(true);
    if (oldToken != null) await userTokenRef.child(oldToken).remove();
    return true;
  }
}
