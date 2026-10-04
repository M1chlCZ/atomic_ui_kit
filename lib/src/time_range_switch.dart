import 'package:flutter/material.dart';

/// A time range offered by a [TimeRangeSwitch].
enum TimeRangeSwitchValue {
  /// The last day.
  day,

  /// The last week.
  week,

  /// The last month.
  month,

  /// The last year.
  year,
}

/// A row of buttons that reports the selected time range.
///
/// The options are 1Y, 1M, 1W and 1D; the selected option is drawn fully
/// opaque and highlighted, the others are dimmed.
class TimeRangeSwitch extends StatefulWidget {
  /// Creates a [TimeRangeSwitch].
  const TimeRangeSwitch({super.key, required this.onChanged, this.color});

  /// Called with the selected range when a range is tapped.
  final ValueChanged<TimeRangeSwitchValue> onChanged;

  /// Highlight color of the selected range.
  ///
  /// Defaults to `Color(0xFF9BD41E)`.
  final Color? color;

  @override
  State<TimeRangeSwitch> createState() => _TimeRangeSwitchState();
}

class _TimeRangeSwitchState extends State<TimeRangeSwitch> {
  var _active = 1;
  final _duration = const Duration(milliseconds: 300);

  TextStyle _labelStyle(BuildContext context, int index) {
    final baseStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    return baseStyle.copyWith(
      color: _active == index
          ? widget.color ?? const Color(0xFF9BD41E)
          : Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.22;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: AnimatedOpacity(
            opacity: _active == 4 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () => _select(TimeRangeSwitchValue.year, 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('1Y', maxLines: 1, style: _labelStyle(context, 4)),
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: AnimatedOpacity(
            opacity: _active == 3 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () => _select(TimeRangeSwitchValue.month, 3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('1M', maxLines: 1, style: _labelStyle(context, 3)),
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: AnimatedOpacity(
            opacity: _active == 2 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () => _select(TimeRangeSwitchValue.week, 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('1W', maxLines: 1, style: _labelStyle(context, 2)),
              ),
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: AnimatedOpacity(
            opacity: _active == 1 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () => _select(TimeRangeSwitchValue.day, 1),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('1D', maxLines: 1, style: _labelStyle(context, 1)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _select(TimeRangeSwitchValue value, int index) {
    setState(() {
      _active = index;
    });
    widget.onChanged(value);
  }
}
