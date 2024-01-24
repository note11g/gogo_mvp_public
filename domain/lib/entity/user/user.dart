import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'soma_role.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@Freezed(equal: false)
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String profileImageUrl,
    required SomaRole somaRole,
  }) = _User;

  factory User.fromJson(dynamic json) => _$UserFromJson(json);

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

