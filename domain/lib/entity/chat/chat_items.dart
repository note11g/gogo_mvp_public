import 'package:gogo_mvp_domain/entity/user/user.dart';

sealed class ChatItem {
  DateTime get time;
}

sealed class NetworkChatItem implements ChatItem {
  String get id;

  @override
  DateTime get time;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkChatItem &&
          runtimeType == other.runtimeType &&
          id == other.id && time == other.time;

  @override
  int get hashCode => id.hashCode ^ time.hashCode;
}

class ChatDate extends ChatItem {
  @override
  final DateTime time;

  ChatDate({required this.time});

  @override
  String toString() {
    return 'ChatDate: $time';
  }
}

abstract interface class ChatEnterOrLeaveRecord extends NetworkChatItem {
  User get user;
}

class ChatEnterRecord extends ChatEnterOrLeaveRecord {
  @override
  final String id;
  @override
  final DateTime time;
  @override
  final User user;


  ChatEnterRecord({
    required this.id,
    required this.time,
    required this.user,
  });

  @override
  String toString() {
    return 'ChatEnterRecord: $user [time: $time, id: $id}';
  }
}

class ChatLeaveRecord extends ChatEnterOrLeaveRecord {
  @override
  final String id;
  @override
  final DateTime time;
  @override
  final User user;

  ChatLeaveRecord({
    required this.id,
    required this.time,
    required this.user,
  });

  @override
  String toString() {
    return 'ChatLeaveRecord: $user [time: $time, id: $id}';
  }
}

class ChatMessage extends NetworkChatItem {
  @override
  final String id;
  @override
  final DateTime time;
  final User user;
  final String message;
  final List<User> readUsers;

  ChatMessage({
    required this.id,
    required this.time,
    required this.user,
    required this.message,
    required this.readUsers,
  });

  @override
  String toString() {
    return "${user.name}(${user.id}): $message [read: ${readUsers.map((e) => e.name).join(", ")}, time: ${time.toIso8601String()}, id: $id]";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          user == other.user;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ time.hashCode ^ user.hashCode;
}
