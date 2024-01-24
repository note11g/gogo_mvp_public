import 'package:gogo_mvp_domain/repository/image_repository.dart';

class UploadProfileImageUseCase {
  final ImageRepository _imageRepository;

  UploadProfileImageUseCase(this._imageRepository);

  Future<String> call({required String filePath}) async {
    return await _imageRepository.uploadProfileImage(localImagePath: filePath);
  }
}
