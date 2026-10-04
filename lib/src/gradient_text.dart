import 'package:flutter/material.dart';

/// Text painted with a [Gradient] through a [ShaderMask].
class GradientText extends StatelessWidget {
  /// Creates a [GradientText] showing [text] with [gradient].
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
    this.align,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The text style of the label.
  final TextStyle? style;

  /// The gradient painted over the text.
  final Gradient gradient;

  /// How the text should be aligned horizontally.
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style, textAlign: align),
    );
  }
}
