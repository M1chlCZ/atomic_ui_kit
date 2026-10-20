import 'package:flutter/material.dart';

import 'atomic_theme.dart';
import 'neu_theme.dart';

/// A neumorphic container that paints the neu shadows behind a rounded
/// surface.
///
/// Each value resolves from the explicit widget argument, then the ambient
/// [NeuTheme] extension, then the ambient [AtomicTheme] extension, then the
/// built-in defaults.
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
  /// When null, the container uses the ambient [NeuTheme.borderRadius], then
  /// [AtomicTheme.radius].
  final double? radius;

  /// Background color of the container.
  ///
  /// When null, the container uses the ambient [NeuTheme.keyBackgroundColor],
  /// then [AtomicTheme.baseColor], then [ThemeData.canvasColor].
  final Color? color;

  /// Shadows painted behind the container.
  ///
  /// When null, the container uses the ambient [NeuTheme.keyShadows], then
  /// the shadows of [AtomicTheme].
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final neuTheme = Theme.of(context).extension<NeuTheme>();
    final atomicTheme = AtomicTheme.of(context);
    final resolvedRadius =
        radius ?? neuTheme?.borderRadius ?? atomicTheme.radius;
    final resolvedColor =
        color ??
        neuTheme?.keyBackgroundColor ??
        atomicTheme.baseColor ??
        Theme.of(context).canvasColor;
    return _getContainer(
      height,
      width,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
        boxShadow: AtomicTheme.resolveShadows(context, shadows: shadows),
      ),
      child: child,
    );
  }

  Container _getContainer(
    double? height,
    double? width, {
    required BoxDecoration decoration,
    required Widget? child,
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
