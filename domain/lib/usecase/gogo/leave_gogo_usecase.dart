import 'package:gogo_mvp_domain/repository/chat_repository.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class LeaveGogoUseCase {
  final GogoRepository _gogoRepository;
  final ChatRepository _chatRepository;

  const LeaveGogoUseCase(this._gogoRepository, this._chatRepository);

  Future<void> call({required String gogoId}) async {
    await _chatRepository.leaveChatRoom(gogoId);
    return _gogoRepository.leaveGogo(gogoId);
  }
}
