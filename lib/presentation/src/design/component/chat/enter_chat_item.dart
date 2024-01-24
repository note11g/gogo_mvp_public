part of go_design_component;

class ChatRoomEnterOrLeaveBox extends StatelessWidget {
  final ChatEnterOrLeaveRecord record;

  const ChatRoomEnterOrLeaveBox({
    super.key,
    required this.record,
  });

  bool get leave => record is ChatLeaveRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
          decoration: BoxDecoration(
            color: GoColors.disabledGray,
            borderRadius: GoRounds.m.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text("${record.user.name}님이 ${leave ? "나가" : "입장하"}셨습니다",
              style: GoTypos.chatDescriptionText(color: GoColors.white))),
    );
  }
}
