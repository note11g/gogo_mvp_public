part of go_design_component;

class GoIconButton extends RawButton {
  GoIconButton({
    required String name,
    Color? iconColor,
    Color? disabledIconColor,
    required double size,
    super.key,
    bool enabled = true,
    VoidCallback? onTap,
    super.padding = const EdgeInsets.all(16),
    super.rounds,
  }) : super(
            onTap: enabled ? onTap : null,
            child: GoIcon(
              name: name,
              color: enabled ? iconColor : (disabledIconColor ?? iconColor),
              size: size,
            ));
}
