import 'package:gogo_mvp_domain/entity/chat/chat_items.dart';
import 'package:gogo_mvp_domain/repository/chat_repository.dart';

class ProvideStreamChatUpdatedMessageUseCase {
  final ChatRepository _chatRepository;

  const ProvideStreamChatUpdatedMessageUseCase(this._chatRepository);

  Stream<NetworkChatItem> call(String gogoId) {
    return _chatRepository.streamChatMessageUpdate(gogoId);
  }
}
