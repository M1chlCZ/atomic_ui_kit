import 'package:flutter/material.dart';

import 'atomic_theme.dart';
import 'neu_theme.dart';

/// A neumorphic text field with an inset surface.
///
/// The field paints the shadows inside the surface: the dark shadow sits at
/// the top left and the light shadow at the bottom right. Focus strengthens
/// both shadows. Each value resolves from the explicit widget argument, then
/// the ambient [NeuTheme] extension, then the ambient [AtomicTheme]
/// extension, then the built-in defaults.
class AtomicTextField extends StatefulWidget {
  /// Creates an [AtomicTextField].
  ///
  /// [maxLines] of 1 keeps the field single-line; larger values grow it.
  /// When [errorText] is set, the error is drawn below the field and the
  /// inset shadow uses the error color.
  const AtomicTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  });

  /// Controller of the text.
  final TextEditingController? controller;

  /// Focus node of the field.
  final FocusNode? focusNode;

  /// Label drawn above the field.
  final String? label;

  /// Hint drawn inside an empty field.
  final String? hint;

  /// Error text drawn below the field.
  final String? errorText;

  /// Widget drawn at the start of the field.
  final Widget? prefixIcon;

  /// Widget drawn at the end of the field.
  final Widget? suffixIcon;

  /// Whether the text is hidden.
  final bool obscureText;

  /// Maximum number of lines.
  final int maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Whether the field accepts input.
  final bool enabled;

  /// Keyboard type of the field.
  final TextInputType? keyboardType;

  /// Action of the keyboard submit key.
  final TextInputAction? textInputAction;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the text.
  final ValueChanged<String>? onSubmitted;

  /// Whether the field requests focus when built.
  final bool autofocus;

  /// Padding around the editable text and the icons.
  final EdgeInsetsGeometry padding;

  @override
  State<AtomicTextField> createState() => _AtomicTextFieldState();
}

class _AtomicTextFieldState extends State<AtomicTextField> {
  late FocusNode _focusNode;
  var _ownsFocusNode = false;
  var _focused = false;

  @override
  void initState() {
    super.initState();
    _attachFocusNode();
  }

  @override
  void didUpdateWidget(AtomicTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusNode();
      _attachFocusNode();
    }
  }

  @override
  void dispose() {
    _detachFocusNode();
    super.dispose();
  }

  void _attachFocusNode() {
    final provided = widget.focusNode;
    if (provided != null) {
      _focusNode = provided;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _detachFocusNode() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neuTheme = theme.extension<NeuTheme>();
    final atomicTheme = AtomicTheme.of(context);
    final scheme = theme.colorScheme;
    final radius = neuTheme?.borderRadius ?? atomicTheme.radius;
    final color =
        neuTheme?.keyBackgroundColor ??
        atomicTheme.baseColor ??
        theme.canvasColor;
    final error = widget.errorText;
    final shadowColorLight = error == null
        ? atomicTheme.lightShadow ?? AtomicTheme.defaultLightShadow
        : scheme.error;
    final shadowColorDark = error == null
        ? atomicTheme.darkShadow ?? AtomicTheme.defaultDarkShadow
        : scheme.error;
    final field = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _focused ? 1 : 0),
        duration: _motionDuration(context, const Duration(milliseconds: 180)),
        builder: (context, focusStrength, child) {
          return CustomPaint(
            painter: _InsetShadowPainter(
              radius: radius,
              light: shadowColorLight,
              dark: shadowColorDark,
              depth: atomicTheme.depth,
              strength: 0.45 + focusStrength * 0.55,
            ),
            child: child,
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: widget.padding,
            child: Row(
              crossAxisAlignment: widget.maxLines == 1
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.prefixIcon != null) ...<Widget>[
                  widget.prefixIcon!,
                  const SizedBox(width: 8),
                ],
                Expanded(child: _buildTextField(theme)),
                if (widget.suffixIcon != null) ...<Widget>[
                  const SizedBox(width: 8),
                  widget.suffixIcon!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
    final label = widget.label;
    return Opacity(
      opacity: widget.enabled ? 1 : 0.55,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (label != null) ...<Widget>[
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
          ],
          field,
          if (error != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(ThemeData theme) {
    final scheme = theme.colorScheme;
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      cursorColor: scheme.primary,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

Duration _motionDuration(BuildContext context, Duration duration) {
  final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  return reduceMotion ? Duration.zero : duration;
}

class _InsetShadowPainter extends CustomPainter {
  const _InsetShadowPainter({
    required this.radius,
    required this.light,
    required this.dark,
    required this.depth,
    required this.strength,
  });

  final double radius;
  final Color light;
  final Color dark;
  final double depth;
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(0.5),
      Radius.circular(radius),
    );
    final band = (size.shortestSide / 4).clamp(4.0, 16.0).toDouble();
    final ring = Path.combine(
      PathOperation.difference,
      Path()..addRRect(shape.inflate(band)),
      Path()..addRRect(shape.deflate(band)),
    );
    final sigma = (depth * 3).clamp(1.5, 8.0).toDouble();
    canvas.save();
    canvas.clipRRect(shape);
    _paintRing(canvas, ring, dark, Offset(depth, depth), sigma);
    _paintRing(canvas, ring, light, Offset(-depth, -depth), sigma);
    canvas.restore();
  }

  void _paintRing(
    Canvas canvas,
    Path ring,
    Color color,
    Offset offset,
    double sigma,
  ) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(
      ring,
      Paint()
        ..color = color.withValues(
          alpha: color.a * strength.clamp(0.0, 1.0).toDouble(),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetShadowPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.light != light ||
        oldDelegate.dark != dark ||
        oldDelegate.depth != depth ||
        oldDelegate.strength != strength;
  }
}
