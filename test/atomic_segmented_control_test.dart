import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const List<AtomicSegment<String>> segments = <AtomicSegment<String>>[
  AtomicSegment<String>(value: '1D', label: '1D'),
  AtomicSegment<String>(value: '1W', label: '1W'),
  AtomicSegment<String>(value: '1M', label: '1M'),
  AtomicSegment<String>(value: '1Y', label: '1Y'),
];

Widget harness({
  required String initial,
  required List<String> changes,
  bool enabled = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: StatefulBuilder(
          builder: (context, setState) {
            return AtomicSegmentedControl<String>(
              segments: segments,
              selected: changes.isEmpty ? initial : changes.last,
              enabled: enabled,
              onChanged: (value) => setState(() => changes.add(value)),
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders one label per segment', (tester) async {
    await tester.pumpWidget(harness(initial: '1D', changes: <String>[]));
    for (final segment in segments) {
      expect(find.text(segment.label), findsOneWidget);
    }
  });

  testWidgets('reports the tapped value once', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(harness(initial: '1D', changes: changes));
    await tester.tap(find.text('1W'));
    await tester.pumpAndSettle();
    expect(changes, <String>['1W']);
  });

  testWidgets('moves the selection with the arrow keys', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(harness(initial: '1D', changes: changes));
    await tester.tap(find.text('1D'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(changes, <String>['1W']);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(changes, <String>['1W', '1D']);
  });

  testWidgets('ignores taps when disabled', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(
      harness(initial: '1D', changes: changes, enabled: false),
    );
    await tester.tap(find.text('1M'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
  });

  testWidgets('marks the selected segment for assistive technologies', (
    tester,
  ) async {
    await tester.pumpWidget(harness(initial: '1W', changes: <String>[]));
    final selected = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == '1W',
      ),
    );
    expect(selected.properties.selected, isTrue);
    expect(selected.properties.button, isTrue);
    final other = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == '1D',
      ),
    );
    expect(other.properties.selected, isFalse);
  });

  testWidgets('falls back to the first segment for an unknown value', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AtomicSegmentedControl<String>(
            segments: segments,
            selected: 'unknown',
            onChanged: (_) {},
          ),
        ),
      ),
    );
    final first = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == '1D',
      ),
    );
    expect(first.properties.selected, isTrue);
  });
}
