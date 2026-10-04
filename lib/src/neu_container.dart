import 'package:flutter/material.dart';

import 'neu_theme.dart';

/// A neumorphic container that paints the neu shadows behind a rounded
/// surface.
///
/// Each value resolves from the explicit widget argument, then the ambient
/// [NeuTheme] extension, then the neu defaults.
class NeuContainer extends StatelessWidget {
  /// Creates a [NeuContainer].
  const NeuContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.radius,
    this.color,
    this.shadows,
  });

  /// Widget shown inside the container.
  final Widget? child;

  /// Fixed height of the container.
  ///
  /// When set, [width] must be set as well.
  final double? height;

  /// Fixed width of the container.
  ///
  /// Only used when [height] is set.
  final double? width;

  /// Border radius of the container.
  ///
  /// When null, the ambient [NeuTheme.borderRadius] is used.
  final double? radius;

  /// Background color of the container.
  ///
  /// When null, the ambient [NeuTheme.keyBackgroundColor] is used, falling
  /// back to [ThemeData.canvasColor].
  final Color? color;

  /// Shadows painted behind the container.
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
        color: resolvedColor,
        borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
        boxShadow: shadows ?? theme.keyShadows,
      ),
      child: Padding(padding: const EdgeInsets.all(0.0), child: child),
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
