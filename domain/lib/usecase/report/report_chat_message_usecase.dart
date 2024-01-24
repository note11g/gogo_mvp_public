import 'package:gogo_mvp_domain/entity/report/reports.dart';
import 'package:gogo_mvp_domain/repository/report_repository.dart';

class ReportChatMessageUseCase {
  final ReportRepository _reportRepository;

  const ReportChatMessageUseCase(this._reportRepository);

  Future<void> call(ChatMessageReport report) async {
    await _reportRepository.reportChatMessage(report);
  }
}
