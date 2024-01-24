part of go_design_component;

class ChatDateItem extends StatelessWidget {
  final ChatDate date;

  const ChatDateItem({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(date.time.toDateString(year: false),
          style: GoTypos.chatDescriptionText()),
    );
  }
}
