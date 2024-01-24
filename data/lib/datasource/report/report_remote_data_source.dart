import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gogo_mvp_domain/entity/report/reports.dart';

class ReportRemoteDataSource {
  final FirebaseFirestore _firestore;

  const ReportRemoteDataSource(this._firestore);

  CollectionReference get _reportCollection => _firestore.collection('report');

  Future<void> reportChatMessage(BaseReport report) async {
    await _reportCollection.doc().set(report.toJson());
  }
}