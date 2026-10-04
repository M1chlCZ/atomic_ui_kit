import 'package:flutter/material.dart';

import 'neu_theme.dart';

/// A neumorphic button that reacts to taps with an ink splash.
///
/// The button paints the neumorphic shadows on an outer [Container] and a
/// rounded [Material] surface on top. Each value resolves from the explicit
/// widget argument, then the ambient [NeuTheme] extension, then the neu
/// defaults.
class NeuButton extends StatelessWidget {
  /// Creates a [NeuButton].
  ///
  /// [onTap] is called when the button is tapped. [animIcon], [icon],
  /// [imageIcon] and [child] are stacked vertically; unset slots are skipped.
  const NeuButton({
    super.key,
    this.color,
    this.onTap,
    this.icon,
    this.imageIcon,
    this.splashColor,
    this.animIcon,
    this.radius,
    this.child,
    this.height,
    this.width,
    this.gradient,
    this.shadows,
  });

  /// Background color of the button surface.
  ///
  /// When null, the ambient [NeuTheme.keyBackgroundColor] is used, falling
  /// back to [ThemeData.canvasColor].
  final Color? color;

  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Icon shown in the button content.
  final Icon? icon;

  /// Animated icon shown above [icon].
  final AnimatedIcon? animIcon;

  /// Splash color of the ink response.
  ///
  /// Defaults to [Colors.white30].
  final Color? splashColor;

  /// Image shown in the button content.
  final Image? imageIcon;

  /// Widget shown at the bottom of the button content.
  final Widget? child;

  /// Fixed height of the button.
  ///
  /// When set, [width] must be set as well.
  final double? height;

  /// Fixed width of the button.
  ///
  /// Only used when [height] is set.
  final double? width;

  /// Border radius of the button surface.
  ///
  /// When null, the ambient [NeuTheme.borderRadius] is used.
  final double? radius;

  /// Gradient painted over the button content with [BlendMode.srcIn].
  ///
  /// When null, the content is painted normally.
  final Gradient? gradient;

  /// Shadows painted behind the button.
  ///
  /// When null, the ambient [NeuTheme.keyShadows] are used.
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<NeuTheme>() ?? const NeuTheme();
    final resolvedRadius = radius ?? theme.borderRadius;
    final resolvedColor =
        color ?? theme.keyBackgroundColor ?? Theme.of(context).canvasColor;
    return _getContainer(
      height,
      width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
        boxShadow: shadows ?? theme.keyShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
        child: Material(
          color: resolvedColor,
          child: InkWell(
            splashColor: splashColor ?? Colors.white30,
            onTap: onTap,
            child: gradient != null
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => gradient!.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: _content,
                  )
                : _content,
          ),
        ),
      ),
    );
  }

  Widget get _content => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      animIcon ?? Container(),
      icon ?? Container(),
      imageIcon ?? Container(),
      child ?? Container(),
    ],
  );

  Container _getContainer(
    double? height,
    double? width, {
    required BoxDecoration decoration,
    required Widget child,
  }) {
    if (height != null) {
      assert(width != null);
      return Container(
        height: height,
        width: width,
        decoration: decoration,
        child: child,
      );
    }
    return Container(decoration: decoration, child: child);
  }
}
