import 'package:firebase_database/firebase_database.dart';

class ChatMessageRequestDto {
  final String userId;
  final String message;

  ChatMessageRequestDto({
    required this.userId,
    required this.message,
  });

  Map<String, dynamic> toJson({required String id}) {
    return {
      "id": id,
      "userId": userId,
      "message": message,
      "time": ServerValue.timestamp,
      "readUsers": [],
    };
  }
}

class ChatEnterRequestDto {
  final String userId;

  ChatEnterRequestDto({required this.userId});

  Map<String, dynamic> toJson({required String id}) {
    return {
      "id": id,
      "userId": userId,
      "time": ServerValue.timestamp,
    };
  }
}

class ChatLeaveRequestDto {
  final String userId;

  ChatLeaveRequestDto({required this.userId});

  Map<String, dynamic> toJson({required String id}) {
    return {
      "id": id,
      "userId": userId,
      "time": ServerValue.timestamp,
      "leave": true,
    };
  }
}