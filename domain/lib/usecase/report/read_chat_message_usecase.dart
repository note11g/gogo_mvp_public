import 'package:gogo_mvp_domain/repository/chat_repository.dart';

class ReadChatMessageUseCase {
  final ChatRepository _chatRepository;

  const ReadChatMessageUseCase(this._chatRepository);

  Future<void> call({required String gogoId, required String messageId}) async {
    return _chatRepository.readMessage(gogoId: gogoId, messageId: messageId);
  }
}
