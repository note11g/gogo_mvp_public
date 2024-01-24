import 'dart:typed_data';

abstract interface class ImageRepository {
  Future<String> uploadProfileImage({required String localImagePath});

  Future<String> uploadChatImage(
      {required String gogoId, required String localImagePath});

  Future<Uint8List> downloadImage(String remoteUrl);
}
