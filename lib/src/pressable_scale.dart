import 'package:flutter/material.dart';

/// Scales its child down while the child is pressed.
///
/// The wrapper is a gesture target, so wrap non-interactive content such as a
/// card or an image. When the platform asks for reduced motion, the scale
/// stays at 1 and the animation duration becomes zero.
class PressableScale extends StatefulWidget {
  /// Creates a [PressableScale] around [child].
  ///
  /// [onPressed] is called when the child is tapped. When [semanticLabel] is
  /// set, the wrapper announces the label and the button role.
  const PressableScale({
    super.key,
    required this.child,
    this.onPressed,
    this.pressedScale = 0.97,
    this.duration = const Duration(milliseconds: 120),
    this.semanticLabel,
  }) : assert(
         pressedScale > 0 && pressedScale <= 1,
         'pressedScale must be in (0, 1]',
       );

  /// Widget shown inside the wrapper.
  final Widget child;

  /// Called when the child is tapped.
  final VoidCallback? onPressed;

  /// Scale applied while the child is pressed.
  final double pressedScale;

  /// Duration of the scale animation.
  final Duration duration;

  /// Semantic label announced for the wrapper.
  final String? semanticLabel;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final enabled = widget.onPressed != null;
    final scale = _pressed && !reduceMotion ? widget.pressedScale : 1.0;
    final gesture = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: scale,
        duration: reduceMotion ? Duration.zero : widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
    if (!enabled) {
      return gesture;
    }
    return Semantics(button: true, label: widget.semanticLabel, child: gesture);
  }
}
