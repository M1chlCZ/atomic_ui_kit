import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A list item that scales and tilts into place when it is first built.
class AnimatedListItem extends StatefulWidget {
  /// Creates an [AnimatedListItem] wrapping [child].
  ///
  /// [keepAlive] keeps the item alive in lazy lists, [scrollDirection] selects
  /// the direction the item animates in from, [height] fixes the item height
  /// and [width] fixes its width.
  const AnimatedListItem({
    super.key,
    required this.child,
    this.keepAlive = false,
    this.scrollDirection = ScrollDirection.forward,
    this.height = 100,
    this.width,
  });

  /// Widget shown by the item.
  final Widget child;

  /// Whether the item should be kept alive in lazy lists.
  final bool keepAlive;

  /// Direction the item animates in from.
  final ScrollDirection scrollDirection;

  /// Height of the item.
  final double height;

  /// Width of the item.
  ///
  /// When null, the item spans the full screen width.
  final double? width;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> perspectiveAnimation;
  late final Animation<AlignmentGeometry> alignmentAnimation;

  static const double perspectiveValue = 0.005;

  @override
  void initState() {
    super.initState();
    final int perspectiveDirectionMultiplier =
        widget.scrollDirection == ScrollDirection.forward ? -1 : 1;

    final AlignmentGeometry directionAlignment =
        widget.scrollDirection == ScrollDirection.forward
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    perspectiveAnimation =
        Tween<double>(
          begin: perspectiveValue * perspectiveDirectionMultiplier,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.easeOut),
          ),
        );

    alignmentAnimation =
        Tween<AlignmentGeometry>(
          begin: directionAlignment,
          end: Alignment.center,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.easeOut),
          ),
        );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: widget.height,
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: animationController,
        child: widget.child,
        builder: (context, child) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 1, perspectiveAnimation.value),
          alignment: alignmentAnimation.value,
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
