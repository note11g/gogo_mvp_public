import 'package:gogo_mvp_domain/repository/chat_repository.dart';
import 'package:gogo_mvp_domain/repository/image_repository.dart';

class SendChatImageUseCase {
  final ImageRepository _imageRepository;
  final ChatRepository _chatRepository;

  const SendChatImageUseCase(this._imageRepository, this._chatRepository);

  Future<void> call({
    required String gogoId,
    required String localImagePath,
  }) async {
    final imageUrl = await _imageRepository.uploadChatImage(
        gogoId: gogoId, localImagePath: localImagePath);
    await _chatRepository.sendMessage(
        gogoId: gogoId, message: '[image:$imageUrl]');
  }
}
