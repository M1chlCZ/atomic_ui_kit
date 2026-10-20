import 'package:flutter/material.dart';

import 'atomic_theme.dart';
import 'neu_theme.dart';

/// A linear progress bar with the neu shadows.
///
/// The bar paints the neumorphic shadows behind a rounded track and fills a
/// part of the track with the progress color. Each value resolves from the
/// explicit widget argument, then the ambient [NeuTheme] extension, then the
/// ambient [AtomicTheme] extension, then the built-in defaults.
class NeumorphicProgress extends StatelessWidget {
  /// Creates a [NeumorphicProgress].
  ///
  /// [value] is a fraction between `0.0` and `1.0`. The bar uses [height] as
  /// its fixed height. The bar announces its progress as a percentage.
  const NeumorphicProgress({
    super.key,
    required this.value,
    this.height = 12,
    this.radius,
    this.color,
    this.trackColor,
    this.shadows,
    this.depth,
    this.semanticLabel,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0.0 and 1.0.');

  /// Progress fraction between `0.0` and `1.0`.
  final double value;

  /// Height of the bar.
  final double height;

  /// Border radius of the bar.
  ///
  /// When null, the bar uses the ambient [NeuTheme.borderRadius], then
  /// [AtomicTheme.radius].
  final double? radius;

  /// Color of the filled part.
  ///
  /// When null, the bar uses [ColorScheme.primary].
  final Color? color;

  /// Color of the track behind the filled part.
  ///
  /// When null, the bar uses the ambient [NeuTheme.keyBackgroundColor], then
  /// [AtomicTheme.baseColor], falling back to [ThemeData.canvasColor].
  final Color? trackColor;

  /// Shadows painted behind the bar.
  ///
  /// When null, the bar uses the ambient [NeuTheme.keyShadows], then the
  /// shadows of [AtomicTheme].
  final List<BoxShadow>? shadows;

  /// Shadow offset of the bar.
  ///
  /// When not null, the bar builds the shadows from this value and the
  /// [AtomicTheme] shadow colors. The blur radius is four times the depth.
  final double? depth;

  /// Semantic label announced for the bar.
  ///
  /// When null, the bar announces only its percentage value.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final neuTheme = Theme.of(context).extension<NeuTheme>();
    final atomicTheme = AtomicTheme.of(context);
    final resolvedRadius =
        radius ?? neuTheme?.borderRadius ?? atomicTheme.radius;
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedTrackColor =
        trackColor ??
        neuTheme?.keyBackgroundColor ??
        atomicTheme.baseColor ??
        Theme.of(context).canvasColor;
    final fraction = value.clamp(0.0, 1.0).toDouble();
    final borderRadius = BorderRadius.all(Radius.circular(resolvedRadius));
    return Semantics(
      label: semanticLabel,
      value: '${(fraction * 100).round()}%',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: resolvedTrackColor,
          borderRadius: borderRadius,
          boxShadow: AtomicTheme.resolveShadows(
            context,
            shadows: shadows,
            depth: depth,
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: FractionallySizedBox(
            widthFactor: fraction,
            heightFactor: 1,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: resolvedColor,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
