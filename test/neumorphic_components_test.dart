import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const BoxShadow customShadow = BoxShadow(
  offset: Offset(3, 3),
  blurRadius: 9,
  color: Color(0xFF123456),
);

Widget host(Widget child, {List<ThemeExtension<dynamic>>? extensions}) {
  return MaterialApp(
    theme: ThemeData(extensions: extensions),
    home: Scaffold(body: Center(child: child)),
  );
}

BoxDecoration outerDecoration(WidgetTester tester, Type type) {
  final container = tester.widget<Container>(
    find
        .descendant(of: find.byType(type), matching: find.byType(Container))
        .first,
  );
  return container.decoration! as BoxDecoration;
}

Finder progressFill() {
  return find
      .descendant(
        of: find.byType(NeumorphicProgress),
        matching: find.byType(Container),
      )
      .last;
}

BoxDecoration fillDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(progressFill());
  return container.decoration! as BoxDecoration;
}

void main() {
  group('NeumorphicCard', () {
    testWidgets('renders its child with the default padding and shadows', (
      tester,
    ) async {
      await tester.pumpWidget(host(const NeumorphicCard(child: Text('card'))));

      expect(find.text('card'), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NeumorphicCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.padding, const EdgeInsets.all(16));

      final decoration = outerDecoration(tester, NeumorphicCard);
      expect(decoration.boxShadow, NeuTheme.defaultKeyShadows);
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets('applies NeuTheme values by default', (tester) async {
      await tester.pumpWidget(
        host(
          const NeumorphicCard(
            padding: EdgeInsets.all(20),
            child: Text('card'),
          ),
          extensions: const [
            NeuTheme(
              keyShadows: [customShadow],
              keyBackgroundColor: Colors.red,
              borderRadius: 8,
            ),
          ],
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NeumorphicCard),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.padding, const EdgeInsets.all(20));

      final decoration = outerDecoration(tester, NeumorphicCard);
      expect(decoration.boxShadow, const [customShadow]);
      expect(decoration.color, Colors.red);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('falls back to AtomicTheme values', (tester) async {
      await tester.pumpWidget(
        host(
          const NeumorphicCard(child: Text('card')),
          extensions: const [
            AtomicTheme(
              baseColor: Colors.red,
              lightShadow: Colors.white,
              darkShadow: Colors.black,
              depth: 2,
              radius: 10,
            ),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeumorphicCard);
      expect(decoration.color, Colors.red);
      expect(decoration.borderRadius, BorderRadius.circular(10));
      expect(decoration.boxShadow!.first.color, Colors.white);
      expect(decoration.boxShadow!.first.offset, const Offset(-2, -2));
      expect(decoration.boxShadow!.first.blurRadius, 8);
      expect(decoration.boxShadow!.last.color, Colors.black);
    });

    testWidgets('explicit values and depth win over the theme', (tester) async {
      await tester.pumpWidget(
        host(
          const NeumorphicCard(
            color: Colors.green,
            radius: 3,
            shadows: [customShadow],
            child: Text('card'),
          ),
          extensions: const [
            NeuTheme(keyShadows: [], keyBackgroundColor: Colors.red),
            AtomicTheme(baseColor: Colors.blue, radius: 20, depth: 4),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeumorphicCard);
      expect(decoration.color, Colors.green);
      expect(decoration.borderRadius, BorderRadius.circular(3));
      expect(decoration.boxShadow, const [customShadow]);

      await tester.pumpWidget(
        host(
          const NeumorphicCard(depth: 5, child: Text('card')),
          extensions: const [
            AtomicTheme(lightShadow: Colors.white, darkShadow: Colors.black),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final deeper = outerDecoration(tester, NeumorphicCard);
      expect(deeper.boxShadow!.first.offset, const Offset(-5, -5));
      expect(deeper.boxShadow!.first.blurRadius, 20);
      expect(deeper.boxShadow!.first.color, Colors.white);
      expect(deeper.boxShadow!.last.color, Colors.black);
    });

    testWidgets('updates on rebuild', (tester) async {
      await tester.pumpWidget(host(const NeumorphicCard(child: Text('first'))));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(
        host(const NeumorphicCard(color: Colors.green, child: Text('second'))),
      );

      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
      expect(outerDecoration(tester, NeumorphicCard).color, Colors.green);
    });

    testWidgets('exposes a semantic label when one is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const NeumorphicCard(semanticLabel: 'Summary', child: Text('x'))),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Summary',
        ),
        findsOneWidget,
      );
    });
  });

  group('NeumorphicProgress', () {
    testWidgets('fills a fraction of the track with a custom height', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 200,
            child: NeumorphicProgress(value: 0.5, height: 20),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(NeumorphicProgress)),
        const Size(200, 20),
      );
      expect(tester.getSize(progressFill()), const Size(100, 20));
    });

    testWidgets('handles zero and full values', (tester) async {
      await tester.pumpWidget(
        host(const SizedBox(width: 200, child: NeumorphicProgress(value: 0))),
      );
      expect(tester.getSize(progressFill()).width, 0);

      await tester.pumpWidget(
        host(const SizedBox(width: 200, child: NeumorphicProgress(value: 1))),
      );
      expect(tester.getSize(progressFill()).width, 200);
    });

    testWidgets('updates when the value changes', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(width: 200, child: NeumorphicProgress(value: 0.25)),
        ),
      );
      expect(tester.getSize(progressFill()).width, 50);

      await tester.pumpWidget(
        host(
          const SizedBox(width: 200, child: NeumorphicProgress(value: 0.75)),
        ),
      );
      expect(tester.getSize(progressFill()).width, 150);
    });

    testWidgets('applies the ambient themes by default', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(width: 200, child: NeumorphicProgress(value: 0.5)),
          extensions: const [
            NeuTheme(
              keyShadows: [customShadow],
              keyBackgroundColor: Colors.amber,
              borderRadius: 8,
            ),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeumorphicProgress);
      expect(decoration.color, Colors.amber);
      expect(decoration.borderRadius, BorderRadius.circular(8));
      expect(decoration.boxShadow, const [customShadow]);
      expect(
        fillDecoration(tester).color,
        Theme.of(
          tester.element(find.byType(NeumorphicProgress)),
        ).colorScheme.primary,
      );

      await tester.pumpWidget(
        host(
          const SizedBox(width: 200, child: NeumorphicProgress(value: 0.5)),
          extensions: const [
            AtomicTheme(
              baseColor: Colors.red,
              lightShadow: Colors.white,
              darkShadow: Colors.black,
              depth: 2,
              radius: 10,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final atomicDecoration = outerDecoration(tester, NeumorphicProgress);
      expect(atomicDecoration.color, Colors.red);
      expect(atomicDecoration.borderRadius, BorderRadius.circular(10));
      expect(atomicDecoration.boxShadow!.first.color, Colors.white);
      expect(atomicDecoration.boxShadow!.first.offset, const Offset(-2, -2));
      expect(atomicDecoration.boxShadow!.first.blurRadius, 8);
    });

    testWidgets('explicit values win over the theme', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 200,
            child: NeumorphicProgress(
              value: 0.5,
              color: Colors.green,
              trackColor: Colors.black,
              radius: 3,
              shadows: [customShadow],
            ),
          ),
          extensions: const [
            NeuTheme(keyShadows: [], keyBackgroundColor: Colors.red),
            AtomicTheme(baseColor: Colors.blue, radius: 20),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeumorphicProgress);
      expect(decoration.color, Colors.black);
      expect(decoration.borderRadius, BorderRadius.circular(3));
      expect(decoration.boxShadow, const [customShadow]);
      expect(fillDecoration(tester).color, Colors.green);
    });

    testWidgets('exposes semantics value and label', (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 200,
            child: NeumorphicProgress(value: 0.4, semanticLabel: 'Upload'),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Upload' &&
              widget.properties.value == '40%',
        ),
        findsOneWidget,
      );
    });
  });
}
