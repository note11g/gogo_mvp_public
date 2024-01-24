import 'dart:typed_data';

import 'package:gogo_mvp_domain/repository/image_repository.dart';

class DownloadImageUseCase {
  final ImageRepository _imageRepository;

  const DownloadImageUseCase(this._imageRepository);

  Future<Uint8List> call({required String remoteUrl}) async {
    return _imageRepository.downloadImage(remoteUrl);
  }
}
