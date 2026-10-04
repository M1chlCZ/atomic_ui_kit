import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Object _unset = Object();

/// Theme values shared by the neumorphic [NeuButton] and [NeuContainer]
/// widgets.
///
/// Register the extension on a [ThemeData] to restyle every neu widget in the
/// subtree:
///
/// ```dart
/// Theme(
///   data: Theme.of(context).copyWith(
///     extensions: const <ThemeExtension<dynamic>>[
///       NeuTheme(keyBackgroundColor: Colors.white),
///     ],
///   ),
///   child: const NeuContainer(child: Text('plain')),
/// );
/// ```
///
/// Widgets resolve each value in this order: the explicit widget argument,
/// then the extension registered on the ambient theme, then the defaults on
/// this class.
@immutable
class NeuTheme extends ThemeExtension<NeuTheme> {
  /// Creates a [NeuTheme].
  ///
  /// The [keyShadows] default to [defaultKeyShadows], [keyBackgroundColor]
  /// falls back to [ThemeData.canvasColor] when null, and [borderRadius]
  /// defaults to `4`.
  const NeuTheme({
    this.keyShadows = defaultKeyShadows,
    this.keyBackgroundColor,
    this.borderRadius = 4.0,
  });

  /// The two shadows that make up the default neumorphic key effect.
  static const List<BoxShadow> defaultKeyShadows = <BoxShadow>[
    BoxShadow(
      offset: Offset(-1, -1),
      blurRadius: 4,
      color: Color.fromRGBO(134, 134, 134, 0.05),
    ),
    BoxShadow(
      offset: Offset(1, 1),
      blurRadius: 4,
      color: Color.fromRGBO(2, 2, 2, 0.25),
    ),
  ];

  /// Shadows painted behind neu widgets.
  final List<BoxShadow> keyShadows;

  /// Background color of neu widgets.
  ///
  /// When null, neu widgets fall back to the ambient
  /// [ThemeData.canvasColor].
  final Color? keyBackgroundColor;

  /// Border radius of neu widgets.
  final double borderRadius;

  @override
  NeuTheme copyWith({
    List<BoxShadow>? keyShadows,
    Object? keyBackgroundColor = _unset,
    double? borderRadius,
  }) {
    return NeuTheme(
      keyShadows: keyShadows ?? this.keyShadows,
      keyBackgroundColor: identical(keyBackgroundColor, _unset)
          ? this.keyBackgroundColor
          : keyBackgroundColor as Color?,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  NeuTheme lerp(ThemeExtension<NeuTheme>? other, double t) {
    if (other is! NeuTheme) {
      return this;
    }
    return NeuTheme(
      keyShadows: BoxShadow.lerpList(keyShadows, other.keyShadows, t)!,
      keyBackgroundColor: Color.lerp(
        keyBackgroundColor,
        other.keyBackgroundColor,
        t,
      ),
      borderRadius: borderRadius + (other.borderRadius - borderRadius) * t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is NeuTheme &&
        listEquals(other.keyShadows, keyShadows) &&
        other.keyBackgroundColor == keyBackgroundColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(keyShadows), keyBackgroundColor, borderRadius);
}
