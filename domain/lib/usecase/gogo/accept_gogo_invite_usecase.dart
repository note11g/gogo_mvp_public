import 'package:gogo_mvp_domain/repository/chat_repository.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class AcceptGogoInviteUseCase {
  final GogoRepository _gogoRepository;
  final ChatRepository _chatRepository;

  const AcceptGogoInviteUseCase(this._gogoRepository, this._chatRepository);

  Future<void> call({required String gogoId}) async {
    await _gogoRepository.acceptGogoInvite(gogoId);
    await _chatRepository.enterChatRoomFirst(gogoId);
  }
}
