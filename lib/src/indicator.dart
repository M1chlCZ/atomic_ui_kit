import 'package:flutter/material.dart';

/// A colored shape followed by a bold label.
class Indicator extends StatelessWidget {
  /// Creates an [Indicator].
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  /// Color of the shape.
  final Color color;

  /// Label shown next to the shape.
  final String text;

  /// Whether the shape is a square.
  ///
  /// When false, the shape is a circle.
  final bool isSquare;

  /// Side length of the shape.
  final double size;

  /// Color of the label.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
