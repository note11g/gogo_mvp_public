import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../user/user.dart';

part 'gogo_info.freezed.dart';
part 'gogo_info.g.dart';

@freezed
class GogoInfo with _$GogoInfo {
  const factory GogoInfo({
    required String id,
    required String title,
    required String tag,
    required User owner,
    required List<User> users,
    required DateTime createdAt,
    required bool public,
  }) = _GogoInfo;

  factory GogoInfo.fromJson(dynamic json) =>
      _$GogoInfoFromJson(json);
}