import 'package:gogo_mvp_data/datasource/report/report_remote_data_source.dart';
import 'package:gogo_mvp_domain/entity/report/reports.dart';
import 'package:gogo_mvp_domain/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _reportRemoteDataSource;
  ReportRepositoryImpl(this._reportRemoteDataSource);

  @override
  Future<void> reportChatMessage(BaseReport report) {
    return _reportRemoteDataSource.reportChatMessage(report);
  }
}
