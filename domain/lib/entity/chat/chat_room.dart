import 'package:gogo_mvp_domain/entity/gogo/gogo_info.dart';

class GogoRoomInfo {
  final GogoInfo gogo;
  final DateTime lastUpdate;

  GogoRoomInfo({
    required this.gogo,
    required this.lastUpdate,
  });

  GogoRoomInfo copyWith({
    GogoInfo? gogo,
    DateTime? lastUpdate,
  }) =>
      GogoRoomInfo(
        gogo: gogo ?? this.gogo,
        lastUpdate: lastUpdate ?? this.lastUpdate,
      );
}
