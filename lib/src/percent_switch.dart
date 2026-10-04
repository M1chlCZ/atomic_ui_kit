import 'dart:async';

import 'package:flutter/material.dart';

/// A row of buttons that reports the selected stake percentage.
///
/// The options are 25 %, 50 %, 75 % and MAX; the selected option is drawn
/// fully opaque and the others are dimmed.
class PercentSwitch extends StatefulWidget {
  /// Creates a [PercentSwitch].
  ///
  /// [width] is the width of a single option. When null, it is 23 % of the
  /// screen width.
  const PercentSwitch({super.key, required this.onChanged, this.width});

  /// Called with the selected percentage, expressed as a fraction between
  /// `0.25` and `1.0`.
  final ValueChanged<double> onChanged;

  /// Width of a single option.
  final double? width;

  @override
  PercentSwitchState createState() => PercentSwitchState();
}

/// State for [PercentSwitch] that exposes [deActivate].
class PercentSwitchState extends State<PercentSwitch> {
  static const int _inactive = 5;
  var _active = _inactive;
  final _duration = const Duration(milliseconds: 300);
  Timer? _pendingSelection;
  var _selectionGeneration = 0;

  /// Clears the selection so all options are dimmed.
  ///
  /// A selection that is still waiting for its delayed visual update is
  /// discarded, so it cannot re-activate the switch afterwards.
  void deActivate() {
    _selectionGeneration++;
    _pendingSelection?.cancel();
    _pendingSelection = null;
    if (!mounted) {
      return;
    }
    setState(() {
      _active = _inactive;
    });
  }

  @override
  void dispose() {
    _selectionGeneration++;
    _pendingSelection?.cancel();
    _pendingSelection = null;
    super.dispose();
  }

  void _select(double percent, int option) {
    widget.onChanged(percent);
    _selectionGeneration++;
    final generation = _selectionGeneration;
    _pendingSelection?.cancel();
    _pendingSelection = Timer(_duration, () {
      if (!mounted || generation != _selectionGeneration) {
        return;
      }
      setState(() {
        _active = option;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? MediaQuery.of(context).size.width * 0.23;
    return SizedBox(
      width: width * 4,
      child: Row(
        children: [
          SizedBox(
            width: width,
            child: AnimatedOpacity(
              opacity: _active == 4 ? 1.0 : 0.4,
              duration: _duration,
              child: TextButton(
                onPressed: () => _select(0.25, 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "25 %",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
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
                onPressed: () => _select(0.5, 3),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "50 %",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
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
                onPressed: () => _select(0.75, 2),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "75 %",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
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
                onPressed: () => _select(1.0, 1),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "MAX",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
