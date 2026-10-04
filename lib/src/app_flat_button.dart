import 'package:flutter/material.dart';

/// A flat, optionally bordered button with an ink splash.
///
/// [animIcon], [icon], [imageIcon] and [child] are stacked vertically; unset
/// slots are skipped.
class AppFlatButton extends StatelessWidget {
  /// Creates an [AppFlatButton].
  const AppFlatButton({
    super.key,
    this.color,
    this.onTap,
    this.icon,
    this.imageIcon,
    this.splashColor,
    this.animIcon,
    this.radius = 4.0,
    this.child,
    this.borderColor,
    this.height,
    this.width,
    this.padding,
    this.borderWidth,
  });

  /// Border radius of the button.
  final double radius;

  /// Background color of the button surface.
  final Color? color;

  /// Color of the optional border.
  final Color? borderColor;

  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Icon shown in the button content.
  final Icon? icon;

  /// Animated icon shown in the button content.
  final AnimatedIcon? animIcon;

  /// Splash and highlight color of the ink response.
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

  /// Padding around the button content.
  final EdgeInsets? padding;

  /// Width of the optional border.
  ///
  /// Defaults to `1.5` when [borderColor] is set.
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return _getContainer(
      height,
      width,
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth ?? 1.5)
            : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Material(
          color: color,
          child: InkWell(
            splashColor: splashColor ?? Colors.white30,
            highlightColor: splashColor ?? Colors.white30,
            onTap: onTap,
            child: Container(
              padding: padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  animIcon ?? Container(),
                  icon ?? Container(),
                  imageIcon ?? Container(),
                  child ?? Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
