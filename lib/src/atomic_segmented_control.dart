import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'atomic_theme.dart';
import 'neu_theme.dart';

/// One option of [AtomicSegmentedControl].
@immutable
class AtomicSegment<T> {
  /// Creates a segment that reports [value] and draws [label].
  ///
  /// [icon] is drawn before the label when set.
  const AtomicSegment({required this.value, required this.label, this.icon});

  /// Value reported when the segment is selected.
  final T value;

  /// Text drawn in the segment.
  final String label;

  /// Icon drawn before the label.
  final IconData? icon;
}

/// A pill selector that reports the selected value.
///
/// The control animates an indicator behind the selected segment. Tap a
/// segment, or focus the control and press the left and right arrow keys.
/// Each value resolves from the explicit widget argument, then the ambient
/// [NeuTheme] extension, then the ambient [AtomicTheme] extension, then the
/// built-in defaults.
class AtomicSegmentedControl<T> extends StatefulWidget {
  /// Creates an [AtomicSegmentedControl].
  ///
  /// [segments] must not be empty. When [selected] matches no segment, the
  /// control marks the first segment as selected. When [enabled] is false,
  /// taps and keys are ignored.
  const AtomicSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.height = 46,
    this.radius,
    this.enabled = true,
    this.semanticLabel,
  }) : assert(segments.length > 0, 'segments must not be empty');

  /// Options of the control.
  final List<AtomicSegment<T>> segments;

  /// Currently selected value.
  final T selected;

  /// Called with the value of the tapped or keyed segment.
  final ValueChanged<T> onChanged;

  /// Height of the control.
  final double height;

  /// Border radius of the control and the indicator.
  ///
  /// When null, the control uses the ambient [NeuTheme.borderRadius], then
  /// [AtomicTheme.radius].
  final double? radius;

  /// Whether the control reacts to taps and keys.
  final bool enabled;

  /// Semantic label announced for the control.
  final String? semanticLabel;

  @override
  State<AtomicSegmentedControl<T>> createState() =>
      _AtomicSegmentedControlState<T>();
}

class _AtomicSegmentedControlState<T> extends State<AtomicSegmentedControl<T>> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'AtomicSegmentedControl');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  int get _selectedIndex {
    final index = widget.segments.indexWhere(
      (segment) => segment.value == widget.selected,
    );
    return index < 0 ? 0 : index;
  }

  void _select(int index) {
    if (!widget.enabled || index < 0 || index >= widget.segments.length) {
      return;
    }
    final value = widget.segments[index].value;
    if (value == widget.selected) {
      return;
    }
    widget.onChanged(value);
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final int delta;
    if (key == LogicalKeyboardKey.arrowRight) {
      delta = 1;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      delta = -1;
    } else {
      return KeyEventResult.ignored;
    }
    final count = widget.segments.length;
    final step = Directionality.of(context) == TextDirection.rtl
        ? -delta
        : delta;
    _select((_selectedIndex + step + count) % count);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neuTheme = theme.extension<NeuTheme>();
    final atomicTheme = AtomicTheme.of(context);
    final radius =
        widget.radius ?? neuTheme?.borderRadius ?? atomicTheme.radius;
    final color =
        neuTheme?.keyBackgroundColor ??
        atomicTheme.baseColor ??
        theme.canvasColor;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);
    final count = widget.segments.length;
    final selectedIndex = _selectedIndex;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final horizontal = count == 1 ? 0.0 : -1 + 2 * selectedIndex / (count - 1);
    final alignment = count == 1
        ? Alignment.center
        : Alignment(isRtl ? -horizontal : horizontal, 0);
    final indicatorRadius = (radius - 4).clamp(0.0, double.infinity);
    final control = Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: AtomicTheme.resolveShadows(context),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: AnimatedAlign(
              alignment: alignment,
              duration: duration,
              curve: Curves.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(indicatorRadius.toDouble()),
                      ),
                      boxShadow: AtomicTheme.resolveShadows(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              for (var index = 0; index < count; index++)
                Expanded(
                  child: _buildSegment(context, index, index == selectedIndex),
                ),
            ],
          ),
        ],
      ),
    );
    final label = widget.semanticLabel;
    return Semantics(
      container: label != null,
      label: label,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        child: control,
      ),
    );
  }

  Widget _buildSegment(BuildContext context, int index, bool selected) {
    final segment = widget.segments[index];
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textColor = scheme.onSurface.withValues(alpha: selected ? 1 : 0.55);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (segment.icon != null) ...<Widget>[
          Icon(segment.icon, size: 16, color: textColor),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            segment.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
    return Semantics(
      button: true,
      enabled: widget.enabled,
      selected: selected,
      label: segment.label,
      onTap: widget.enabled ? () => _select(index) : null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled
            ? () {
                _focusNode.requestFocus();
                _select(index);
              }
            : null,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: content,
          ),
        ),
      ),
    );
  }
}
