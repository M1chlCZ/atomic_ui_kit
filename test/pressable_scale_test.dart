import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {bool reduceMotion = false}) {
  return MaterialApp(
    builder: (context, app) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: app!,
      );
    },
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('scales down while pressed and restores on release', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      host(
        PressableScale(
          onPressed: () => presses++,
          child: const SizedBox(width: 120, height: 80),
        ),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PressableScale)),
    );
    await tester.pump();
    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      0.97,
    );
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1.0);
    expect(presses, 1);
  });

  testWidgets('keeps the scale at one with reduced motion', (tester) async {
    await tester.pumpWidget(
      host(
        PressableScale(
          onPressed: () {},
          child: const SizedBox(width: 120, height: 80),
        ),
        reduceMotion: true,
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PressableScale)),
    );
    await tester.pump();
    final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
    expect(scale.scale, 1.0);
    expect(scale.duration, Duration.zero);
    await gesture.up();
  });

  testWidgets('announces the button role', (tester) async {
    await tester.pumpWidget(
      host(
        PressableScale(
          onPressed: () {},
          semanticLabel: 'Open details',
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );
    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Open details',
      ),
    );
    expect(semantics.properties.button, isTrue);
  });

  testWidgets('does not scale without an onPressed callback', (tester) async {
    await tester.pumpWidget(
      host(const PressableScale(child: SizedBox(width: 80, height: 80))),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PressableScale)),
    );
    await tester.pump();
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1.0);
    await gesture.up();
  });

  testWidgets('activates with Enter when focused', (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      host(
        PressableScale(
          onPressed: () => presses++,
          child: const SizedBox(width: 80, height: 80),
        ),
      ),
    );
    await tester.tap(find.byType(PressableScale));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(presses, 2);
  });
}
