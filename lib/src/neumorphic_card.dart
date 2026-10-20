import 'package:flutter/material.dart';

import 'atomic_theme.dart';
import 'neu_theme.dart';

/// A neumorphic card with padding around its child.
///
/// The card paints the neumorphic shadows behind a rounded surface. Each value
/// resolves from the explicit widget argument, then the ambient [NeuTheme]
/// extension, then the ambient [AtomicTheme] extension, then the built-in
/// defaults.
class NeumorphicCard extends StatelessWidget {
  /// Creates a [NeumorphicCard] around [child].
  ///
  /// [padding] is `EdgeInsets.all(16)` by default. When [semanticLabel] is
  /// not null, the card adds a [Semantics] node.
  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius,
    this.color,
    this.shadows,
    this.depth,
    this.semanticLabel,
  });

  /// Widget shown inside the card.
  final Widget child;

  /// Padding between the card edge and [child].
  final EdgeInsetsGeometry padding;

  /// Border radius of the card.
  ///
  /// When null, the card uses the ambient [NeuTheme.borderRadius], then
  /// [AtomicTheme.radius].
  final double? radius;

  /// Background color of the card.
  ///
  /// When null, the card uses the ambient [NeuTheme.keyBackgroundColor], then
  /// [AtomicTheme.baseColor], falling back to [ThemeData.canvasColor].
  final Color? color;

  /// Shadows painted behind the card.
  ///
  /// When null, the card uses the ambient [NeuTheme.keyShadows], then the
  /// shadows of [AtomicTheme].
  final List<BoxShadow>? shadows;

  /// Shadow offset of the card.
  ///
  /// When not null, the card builds the shadows from this value and the
  /// [AtomicTheme] shadow colors. The blur radius is four times the depth.
  final double? depth;

  /// Semantic label announced for the card.
  ///
  /// When null, the card adds no label.
  final String? semanticLabel;

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
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
        boxShadow: AtomicTheme.resolveShadows(
          context,
          shadows: shadows,
          depth: depth,
        ),
      ),
      child: child,
    );
    final label = semanticLabel;
    if (label == null) {
      return card;
    }
    return Semantics(container: true, label: label, child: card);
  }
}
