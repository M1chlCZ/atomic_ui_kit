import 'package:flutter/material.dart';

/// A button that opens a dropdown menu in an overlay and reports the selected
/// item.
class DropdownMenuIcon<T> extends StatefulWidget {
  /// Creates a [DropdownMenuIcon].
  ///
  /// [items] are shown in the overlay, [onChange] receives the selected value
  /// and its index, and [currentIndex] selects the initially shown item
  /// (`-1` shows [child] instead).
  ///
  /// [currentIndex] must be `-1` or a valid index into [items].
  const DropdownMenuIcon({
    super.key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    required this.currentIndex,
  }) : assert(
         currentIndex == -1 || currentIndex < items.length,
         'currentIndex must be -1 or a valid index into items.',
       );

  /// The child widget for the button. It is ignored while [currentIndex] is
  /// not `-1`.
  final Widget child;

  /// Called when the selected option changes.
  ///
  /// It receives the selected value and the index of the option. When null,
  /// selecting an option still updates the button but reports nothing.
  final void Function(T, int)? onChange;

  /// The options shown in the dropdown.
  final List<DropdownItem<T>> items;

  /// Style of the dropdown overlay.
  final DropdownStyle dropdownStyle;

  /// Style of the dropdown button.
  final DropdownButtonStyle dropdownButtonStyle;

  /// Icon of the dropdown button.
  ///
  /// Defaults to a caret.
  final Icon? icon;

  /// Whether the trailing icon is hidden.
  final bool hideIcon;

  /// The index of the initially shown item.
  final int currentIndex;

  /// Whether the icon is leading instead of trailing.
  final bool leadingIcon;

  @override
  State<DropdownMenuIcon<T>> createState() => _DropdownMenuIconState<T>();
}

class _DropdownMenuIconState<T> extends State<DropdownMenuIcon<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isClosing = false;
  int _currentIndex = -1;
  late final AnimationController _animationController;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _removeOverlayEntry();
    _animationController.dispose();
    super.dispose();
  }

  int get _visibleIndex =>
      _currentIndex >= 0 && _currentIndex < widget.items.length
      ? _currentIndex
      : -1;

  @override
  Widget build(BuildContext context) {
    final style = widget.dropdownButtonStyle;
    final visibleIndex = _visibleIndex;
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: style.width,
        height: style.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: style.primaryColor,
            side: const BorderSide(width: 0, color: Colors.transparent),
            padding: style.padding,
            backgroundColor: style.backgroundColor,
            elevation: style.elevation,
            shape: style.shape,
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment:
                style.mainAxisAlignment ?? MainAxisAlignment.center,
            textDirection: widget.leadingIcon
                ? TextDirection.rtl
                : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (visibleIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[visibleIndex],
              ],
              if (!widget.hideIcon)
                RotationTransition(
                  turns: _rotateAnimation,
                  child: widget.icon ?? const Icon(Icons.arrow_drop_down_sharp),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox) {
      throw FlutterError(
        'DropdownMenuIcon cannot open before it has been laid out.',
      );
    }

    final size = renderBox.size;

    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle.elevation ?? 0,
                    borderRadius:
                        widget.dropdownStyle.borderRadius ?? BorderRadius.zero,
                    color: widget.dropdownStyle.color,
                    child: SizeTransition(
                      alignment: const AlignmentDirectional(-1.0, 1.0),
                      sizeFactor: _expandAnimation,
                      child: ConstrainedBox(
                        constraints:
                            widget.dropdownStyle.constraints ??
                            BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding:
                              widget.dropdownStyle.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items.asMap().entries.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => _currentIndex = item.key);
                                widget.onChange?.call(
                                  item.value.value,
                                  item.key,
                                );
                                _toggleDropdown();
                              },
                              child: item.value,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isOpen || _isClosing || !mounted) {
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _animationController.forward();
  }

  Future<void> _closeDropdown() async {
    if (!_isOpen || _isClosing) {
      return;
    }
    _isClosing = true;
    await _animationController.reverse();
    _isClosing = false;
    _removeOverlayEntry();
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _removeOverlayEntry() {
    final entry = _overlayEntry;
    _overlayEntry = null;
    entry?.remove();
  }
}

/// A single option in a [DropdownMenuIcon].
///
/// It wraps the widget shown in the menu and holds the value reported through
/// [DropdownMenuIcon.onChange].
class DropdownItem<T> extends StatelessWidget {
  /// Creates a [DropdownItem] holding [value] and showing [child].
  const DropdownItem({super.key, required this.value, required this.child});

  /// Value reported when this item is selected.
  ///
  /// [T] may itself be a nullable type to allow `null` values.
  final T value;

  /// Widget shown for this item.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Style of the dropdown button of a [DropdownMenuIcon].
class DropdownButtonStyle {
  /// Creates a [DropdownButtonStyle].
  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });

  /// Alignment of the button content.
  final MainAxisAlignment? mainAxisAlignment;

  /// Shape of the button.
  final OutlinedBorder? shape;

  /// Elevation of the button.
  final double? elevation;

  /// Background color of the button.
  final Color? backgroundColor;

  /// Padding around the button content.
  final EdgeInsets? padding;

  /// Constraints of the button.
  final BoxConstraints? constraints;

  /// Fixed width of the button.
  final double? width;

  /// Fixed height of the button.
  final double? height;

  /// Foreground color of the button.
  final Color? primaryColor;
}

/// Style of the dropdown overlay of a [DropdownMenuIcon].
class DropdownStyle {
  /// Creates a [DropdownStyle].
  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });

  /// Border radius of the overlay.
  final BorderRadius? borderRadius;

  /// Elevation of the overlay.
  final double? elevation;

  /// Background color of the overlay.
  final Color? color;

  /// Padding around the options in the overlay.
  final EdgeInsets? padding;

  /// Constraints of the overlay.
  final BoxConstraints? constraints;

  /// Position of the top left of the dropdown relative to the top left of the
  /// button.
  final Offset? offset;

  /// Width of the overlay.
  ///
  /// The button width must be set for this to take effect.
  final double? width;
}
