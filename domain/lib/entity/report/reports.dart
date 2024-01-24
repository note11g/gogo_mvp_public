sealed class BaseReport {
  String get reportId;

  String get reportMessage;

  Map<String, dynamic> toJson() => {
    "reportId": reportId,
    "reportMessage": reportMessage,
  };
}

class ChatMessageReport extends BaseReport {
  final String gogoId;

  final String chatId;

  @override
  final String reportMessage;

  ChatMessageReport({
    required this.gogoId,
    required this.chatId,
    required this.reportMessage,
  });

  @override
  String get reportId => "$gogoId:$chatId:$nowTimestamp";

  int get nowTimestamp => DateTime.now().millisecondsSinceEpoch;
}
