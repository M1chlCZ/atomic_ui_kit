import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

/// A badge showing a price change percentage.
///
/// Positive percentages are green and prefixed with `+`; zero and negative
/// percentages are red. The width grows with the magnitude of the value.
class PriceBadge extends StatefulWidget {
  /// Creates a [PriceBadge].
  ///
  /// [percentage] is the price change in percent. When null, the badge shows
  /// `0.00%`.
  const PriceBadge({super.key, required this.percentage});

  /// The price change in percent.
  final Decimal? percentage;

  @override
  State<PriceBadge> createState() => _PriceBadgeState();
}

class _PriceBadgeState extends State<PriceBadge> {
  double _perc = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.percentage != null) {
      _perc = widget.percentage!.toDouble();
    }
  }

  String _getNum(double num) {
    if (num > 0) {
      return "+${num.toStringAsFixed(2)}";
    }
    return num.toStringAsFixed(2);
  }

  double? _getWidth(double num) {
    if (num < 0) {
      num = num * -1.0;
    }

    if (num < 10) {
      return 60.0;
    } else if (num < 100) {
      return 60.0;
    } else if (num < 1000) {
      return 75.0;
    }
    return 85.0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(_perc),
      child: Center(
        child: Opacity(
          opacity: 0.9,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${_getNum(_perc)}%",
              maxLines: 1,
              style: TextStyle(
                color: _perc > 0
                    ? const Color(0xFF9BD421)
                    : const Color(0xFFF35656),
                fontWeight: FontWeight.w800,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
