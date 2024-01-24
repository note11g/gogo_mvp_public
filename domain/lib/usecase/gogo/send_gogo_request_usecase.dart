import 'package:gogo_mvp_domain/repository/chat_repository.dart';

import '../../repository/gogo_repository.dart';

class SendGogoRequestUseCase {
  final GogoRepository _gogoRepository;
  final ChatRepository _chatRepository;

  const SendGogoRequestUseCase(this._gogoRepository, this._chatRepository);

  Future<String> call({required String title, required String tag}) async {
    final gogoId =
        await _gogoRepository.sendGogoRequest(title: title, tag: tag);
    await _chatRepository.enterChatRoomFirst(gogoId);
    return gogoId;
  }
}
