import 'dart:typed_data';

import 'package:gogo_mvp_data/datasource/auth/auth_local_data_source.dart';
import 'package:gogo_mvp_data/types/enum/upload_image_type.dart';
import 'package:gogo_mvp_domain/repository/image_repository.dart';
import 'package:uuid/uuid.dart';
import '../datasource/image/image_remote_data_source.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _imageRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  ImageRepositoryImpl(this._imageRemoteDataSource, this._authLocalDataSource);

  @override
  Future<String> uploadProfileImage({required String localImagePath}) async {
    final uid = _authLocalDataSource.getUserId();
    final extension = localImagePath.split(".").last;
    return _imageRemoteDataSource.uploadImage(localImagePath,
        fileName: "$uid.$extension", type: UploadImageType.profile);
  }

  @override
  Future<String> uploadChatImage(
      {required String gogoId, required String localImagePath}) async {
    final imageId = const Uuid().v4();
    final extension = localImagePath.split(".").last;
    return _imageRemoteDataSource.uploadImage(localImagePath,
        fileName: "$gogoId/$imageId.$extension", type: UploadImageType.chat);
  }

  @override
  Future<Uint8List> downloadImage(String remoteUrl) {
    return _imageRemoteDataSource.downloadAndSaveImage(remoteUrl);
  }
}
