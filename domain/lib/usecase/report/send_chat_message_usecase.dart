import 'package:gogo_mvp_domain/repository/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository _chatRepository;

  const SendChatMessageUseCase(this._chatRepository);

  Future<void> call({
    required String gogoId,
    required String message,
  }) async {
    await _chatRepository.sendMessage(gogoId: gogoId, message: message);
  }
}
