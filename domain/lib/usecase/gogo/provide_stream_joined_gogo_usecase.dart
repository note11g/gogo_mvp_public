import 'package:gogo_mvp_domain/entity/chat/chat_room.dart';
import 'package:gogo_mvp_domain/repository/gogo_repository.dart';

class ProvideStreamJoinedGogoUseCase {
  final GogoRepository _gogoRepository;

  const ProvideStreamJoinedGogoUseCase(this._gogoRepository);

  Stream<List<GogoRoomInfo>> call() {
    return _gogoRepository.streamJoinedGogoRoom();
  }
}
