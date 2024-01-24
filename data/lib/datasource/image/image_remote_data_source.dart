import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gogo_mvp_data/types/enum/upload_image_type.dart';

class ImageRemoteDataSource {
  final FirebaseStorage _firebaseStorage;
  final Dio _dio;

  ImageRemoteDataSource(this._firebaseStorage, this._dio);

  Reference get _ref => _firebaseStorage.ref();

  /// [fileName]을 지정하지 않으면 [filePath]의 마지막 경로를 사용합니다.
  Future<String> uploadImage(
    String filePath, {
    String? fileName,
    required UploadImageType type,
  }) async {
    final file = File(filePath);
    fileName ??= file.uri.pathSegments.last;
    final db = _ref.child(type.name);
    final saveRef = db.child(fileName);
    try {
      await saveRef.putFile(file);
      final url = await saveRef.getDownloadURL();
      return url;
    } catch (e) {
      log("프로필 업로드 실패", error: e);
      rethrow;
    }
  }

  Future<Uint8List> downloadAndSaveImage(String url) async {
    final res =
        await _dio.get(url, options: Options(responseType: ResponseType.bytes));
    return res.data as Uint8List;
  }
}
