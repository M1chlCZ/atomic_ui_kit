import 'package:flutter/material.dart';

import 'neu_theme.dart';

const Object _unset = Object();

/// Theme values shared by the widgets of this package.
///
/// Register the extension on a [ThemeData] to restyle the widgets in the
/// subtree:
///
/// ```dart
/// Theme(
///   data: Theme.of(context).copyWith(
///     extensions: const <ThemeExtension<dynamic>>[
///       AtomicTheme(baseColor: Color(0xFF252F45), depth: 2),
///     ],
///   ),
///   child: const NeumorphicCard(child: Text('themed')),
/// );
/// ```
///
/// Widgets resolve each value in this order: the explicit widget argument,
/// the [NeuTheme] extension, this extension, and the built-in defaults.
@immutable
class AtomicTheme extends ThemeExtension<AtomicTheme> {
  /// Creates an [AtomicTheme].
  ///
  /// [baseColor] falls back to [ThemeData.canvasColor] in widgets.
  /// [lightShadow] and [darkShadow] fall back to [defaultLightShadow] and
  /// [defaultDarkShadow].
  const AtomicTheme({
    this.baseColor,
    this.lightShadow,
    this.darkShadow,
    this.depth = defaultDepth,
    this.radius = defaultRadius,
  });

  /// Default color of the light neumorphic shadow at the top left.
  static const Color defaultLightShadow = Color.fromRGBO(134, 134, 134, 0.05);

  /// Default color of the dark neumorphic shadow at the bottom right.
  static const Color defaultDarkShadow = Color.fromRGBO(2, 2, 2, 0.25);

  /// Default shadow offset of the neumorphic shadows.
  static const double defaultDepth = 1.0;

  /// Default border radius of the widgets.
  static const double defaultRadius = 4.0;

  /// Base color of neumorphic surfaces.
  ///
  /// When null, the widgets use [ThemeData.canvasColor].
  final Color? baseColor;

  /// Color of the light shadow.
  ///
  /// When null, the shadows use [defaultLightShadow].
  final Color? lightShadow;

  /// Color of the dark shadow.
  ///
  /// When null, the shadows use [defaultDarkShadow].
  final Color? darkShadow;

  /// Shadow offset of the neumorphic shadows.
  ///
  /// The blur radius is four times this value. The default depth of `1`
  /// reproduces the built-in shadows of the package.
  final double depth;

  /// Border radius of the widgets.
  final double radius;

  /// Returns the [AtomicTheme] of [context].
  ///
  /// When the ambient theme registers no [AtomicTheme] extension, the method
  /// returns `const AtomicTheme()`.
  static AtomicTheme of(BuildContext context) =>
      Theme.of(context).extension<AtomicTheme>() ?? const AtomicTheme();

  /// Builds the two neumorphic shadows from the shadow colors and the depth.
  ///
  /// The light shadow sits at the top left and the dark shadow at the bottom
  /// right. The blur radius is always four times the offset. A non-null
  /// [depth] argument replaces [AtomicTheme.depth].
  List<BoxShadow> buildShadows({double? depth}) {
    final resolvedDepth = depth ?? this.depth;
    return <BoxShadow>[
      BoxShadow(
        offset: Offset(-resolvedDepth, -resolvedDepth),
        blurRadius: resolvedDepth * 4,
        color: lightShadow ?? defaultLightShadow,
      ),
      BoxShadow(
        offset: Offset(resolvedDepth, resolvedDepth),
        blurRadius: resolvedDepth * 4,
        color: darkShadow ?? defaultDarkShadow,
      ),
    ];
  }

  /// Resolves the shadow list of a widget against [context].
  ///
  /// Returns [shadows] when [shadows] is not null. Returns the ambient
  /// [NeuTheme.keyShadows] when a [NeuTheme] exists and [depth] is null.
  /// Builds the shadows from this extension in every other case.
  static List<BoxShadow> resolveShadows(
    BuildContext context, {
    List<BoxShadow>? shadows,
    double? depth,
  }) {
    if (shadows != null) {
      return shadows;
    }
    final neuTheme = Theme.of(context).extension<NeuTheme>();
    if (depth == null && neuTheme != null) {
      return neuTheme.keyShadows;
    }
    return AtomicTheme.of(context).buildShadows(depth: depth);
  }

  @override
  AtomicTheme copyWith({
    Object? baseColor = _unset,
    Object? lightShadow = _unset,
    Object? darkShadow = _unset,
    double? depth,
    double? radius,
  }) {
    return AtomicTheme(
      baseColor: identical(baseColor, _unset)
          ? this.baseColor
          : baseColor as Color?,
      lightShadow: identical(lightShadow, _unset)
          ? this.lightShadow
          : lightShadow as Color?,
      darkShadow: identical(darkShadow, _unset)
          ? this.darkShadow
          : darkShadow as Color?,
      depth: depth ?? this.depth,
      radius: radius ?? this.radius,
    );
  }

  @override
  AtomicTheme lerp(ThemeExtension<AtomicTheme>? other, double t) {
    if (other is! AtomicTheme) {
      return this;
    }
    return AtomicTheme(
      baseColor: Color.lerp(baseColor, other.baseColor, t),
      lightShadow: Color.lerp(lightShadow, other.lightShadow, t),
      darkShadow: Color.lerp(darkShadow, other.darkShadow, t),
      depth: depth + (other.depth - depth) * t,
      radius: radius + (other.radius - radius) * t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AtomicTheme &&
        other.baseColor == baseColor &&
        other.lightShadow == lightShadow &&
        other.darkShadow == darkShadow &&
        other.depth == depth &&
        other.radius == radius;
  }

  @override
  int get hashCode =>
      Object.hash(baseColor, lightShadow, darkShadow, depth, radius);
}
