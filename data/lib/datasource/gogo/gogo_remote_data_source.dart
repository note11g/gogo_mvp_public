import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_mvp_data/types/dto/gogo/gogo_info_dto.dart';
import 'package:gogo_mvp_data/types/dto/gogo/gogo_request_dto.dart';
import 'package:uuid/uuid.dart';

class GogoRemoteDataSource {
  final FirebaseFirestore _firestore;

  GogoRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _gogoRequestCollection =>
      _firestore.collection("gogo");

  CollectionReference<Map<String, dynamic>> get _gogoInviteCollection =>
      _firestore.collection("gogo_invite");

  Query<Map<String, dynamic>> _unreadGogoInviteQuery(String userId) =>
      _gogoInviteCollection.where("unread_users", arrayContains: userId);

  Future<String> sendGogoRequest(GogoRequestDto request) async {
    final String gogoId = const Uuid().v4();
    await _gogoRequestCollection.doc(gogoId).set(request
        .copyWith(id: gogoId, createdAt: FieldValue.serverTimestamp())
        .toJson());

    final inviteCreateSuccessful = await _checkGogoInviteSendSuccessful(gogoId);
    if (!inviteCreateSuccessful) throw Exception("Failed to create invite");

    return gogoId;
  }

  Future<bool> _checkGogoInviteSendSuccessful(String gogoId) async {
    final completer = Completer<bool>();
    bool isFirstSubscriptionValue = true;
    final documentRef = _gogoInviteCollection.doc(gogoId);
    final subscription = documentRef.snapshots().listen((document) {
      if (document.exists || !isFirstSubscriptionValue) {
        completer.complete(document.exists);
        return;
      }
      isFirstSubscriptionValue = false;
    });
    final inviteCreateSuccessful = await completer.future
        .timeout(const Duration(seconds: 10), onTimeout: () => false);
    subscription.cancel();
    return inviteCreateSuccessful;
  }

  Future<List<GogoInfoDto>> getInvitedGogoRequest(String userId) async {
    final invitedGogoIdList = await _unreadGogoInviteQuery(userId)
        .get()
        .then((value) => value.docs.map((snapshot) => snapshot.id).toList());

    if (invitedGogoIdList.isEmpty) return [];

    return _getGogoRequestsByIdList(invitedGogoIdList);
  }

  Stream<List<GogoInfoDto>> streamInviteGogoRequests(String userId) {
    return _unreadGogoInviteQuery(userId).snapshots().asyncMap((event) async {
      final invitedGogoIdList =
          event.docs.map((snapshot) => snapshot.id).toList();

      if (invitedGogoIdList.isEmpty) return [];
      return await _getGogoRequestsByIdList(invitedGogoIdList);
    });
  }

  Future<List<GogoInfoDto>> _getGogoRequestsByIdList(List<String> idList) {
    return _gogoRequestCollection.where("id", whereIn: idList).get().then(
        (value) => value.docs
            .map((snapshot) => GogoInfoDto.fromJson(snapshot.data()))
            .toList()); // todo : 쿼리 개수 제한 걸리지 않나 확인
  }

  Future<void> readGogoInvite(String gogoId, String userId) async {
    final gogoInviteDoc = _gogoInviteCollection.doc(gogoId);
    try {
      await gogoInviteDoc.update({
        "unread_users": FieldValue.arrayRemove([userId]),
      });
    } on FirebaseException catch (e) {
      if (e.code != "not-found") rethrow;
    }
  }

  Future<void> acceptGogoInvite(String gogoId, String userId) async {
    final gogoDoc = _gogoRequestCollection.doc(gogoId);
    await gogoDoc.update({
      "users": FieldValue.arrayUnion([userId]),
    });
  }

  Stream<List<GogoInfoDto>> streamJoinedGogoList(String userId) {
    return _gogoRequestCollection
        .where("users", arrayContains: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((snapshot) => GogoInfoDto.fromJson(snapshot.data()))
            .toList());
  }

  Future<GogoInfoDto?> getGogoInfo(String gogoId) async {
    final gogoDoc = await _gogoRequestCollection.doc(gogoId).get();
    final rawGogoInfo = gogoDoc.data();
    return rawGogoInfo == null ? null : GogoInfoDto.fromJson(rawGogoInfo);
  }

  Future<void> leaveGogo(String gogoId, String userId) async {
    final gogoDoc = _gogoRequestCollection.doc(gogoId);
    await gogoDoc.update({
      "users": FieldValue.arrayRemove([userId]),
    });
  }
}
