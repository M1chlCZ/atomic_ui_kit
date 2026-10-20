import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Scales its child down while the child is pressed.
///
/// The wrapper is a gesture target, so wrap non-interactive content such as a
/// card or an image. When the platform asks for reduced motion, the scale
/// stays at 1 and the animation duration becomes zero.
///
/// Keyboard users can focus the wrapper with Tab and activate it with Enter
/// or Space.
class PressableScale extends StatefulWidget {
  /// Creates a [PressableScale] around [child].
  ///
  /// [onPressed] is called when the child is tapped or activated with the
  /// keyboard. When [semanticLabel] is set, the wrapper announces the label
  /// and the button role.
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

  /// Called when the child is tapped or activated with the keyboard.
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
  final FocusNode _focusNode = FocusNode(debugLabel: 'PressableScale');
  var _pressed = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      widget.onPressed?.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final enabled = widget.onPressed != null;
    final scale = _pressed && !reduceMotion ? widget.pressedScale : 1.0;
    final content = Focus(
      focusNode: _focusNode,
      canRequestFocus: enabled,
      onKeyEvent: _handleKey,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled
            ? (_) {
                _focusNode.requestFocus();
                _setPressed(true);
              }
            : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: reduceMotion ? Duration.zero : widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
    if (!enabled) {
      return content;
    }
    return Semantics(button: true, label: widget.semanticLabel, child: content);
  }
}
