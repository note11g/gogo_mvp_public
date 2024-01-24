part of go_design_component;

class MiniProfileView extends StatelessWidget {
  final String name;
  final String profileUrl;
  final bool isOwner;

  const MiniProfileView({
    super.key,
    required this.name,
    required this.profileUrl,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          ProfilePhotoView(image: profileUrl, size: 32),
          const GoSpacer(12),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(name, style: GoTypos.profileNameTextAtAskJoin()),
            if (isOwner)
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: GoIcon(
                    name: "owner", size: 14, color: GoColors.primaryOrange),
              ),
          ]),
        ]));
  }
}