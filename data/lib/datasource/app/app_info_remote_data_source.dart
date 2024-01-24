import 'package:firebase_database/firebase_database.dart';
import 'package:gogo_mvp_domain/entity/app_info/app_version_info.dart';

class AppInfoRemoteDataSource {
  final FirebaseDatabase _firebaseDatabase;

  AppInfoRemoteDataSource(this._firebaseDatabase);

  DatabaseReference get _appInfoDB => _firebaseDatabase.ref('app_info');

  Future<AppVersionInfo> getAppVersionInfo() async {
    final appVersionDB = _appInfoDB.child('version_info');
    final rawData = await appVersionDB.get().then((snapshot) => snapshot.value);
    if (rawData == null) throw Exception('App version info is null');
    final rawMap = (rawData as Map).cast<String, dynamic>();
    return AppVersionInfo.fromJson(rawMap);
  }

  Future<List<String>> getTags() async {
    final tagsDB = _appInfoDB.child('tags');
    final rawData = await tagsDB.get().then((snapshot) => snapshot.value);
    final rawList = rawData! as List<dynamic>;
    return rawList.where((tag) => tag != null).toList().cast<String>();
  }
}
