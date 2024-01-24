import 'package:gogo_mvp_domain/entity/report/reports.dart';

abstract interface class ReportRepository {
  Future<void> reportChatMessage(BaseReport report);
}
