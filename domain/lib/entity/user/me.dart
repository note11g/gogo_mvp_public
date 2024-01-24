import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gogo_mvp_domain/entity/user/soma_role.dart';
import 'package:gogo_mvp_domain/entity/user/user.dart';

part 'me.freezed.dart';

part 'me.g.dart';

@freezed
class Me with _$Me {
  const factory Me({
    required String id,
    required String name,
    required String profileImageUrl,
    required String email,
    required SomaRole somaRole,
    required List<String> tags,
  }) = _Me;

  factory Me.fromJson(dynamic json) => _$MeFromJson(json);

  const Me._();
  
  bool get isNewAccount => somaRole == SomaRole.none;
}
