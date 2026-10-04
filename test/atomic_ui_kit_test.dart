import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
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

void main() {
  group('NeuButton', () {
    testWidgets('invokes onTap and renders child and icon', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          NeuButton(
            onTap: () => taps++,
            icon: const Icon(Icons.add),
            child: const Text('Press me'),
          ),
        ),
      );

      expect(find.text('Press me'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(NeuButton));
      expect(taps, 1);
    });

    testWidgets('applies theme shadows, background and radius by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NeuButton(child: Text('themed')),
          extensions: const [
            NeuTheme(
              keyShadows: [customShadow],
              keyBackgroundColor: Colors.red,
              borderRadius: 8,
            ),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeuButton);
      expect(decoration.boxShadow, const [customShadow]);
      expect(decoration.borderRadius, BorderRadius.circular(8));

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(NeuButton),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, Colors.red);
    });

    testWidgets('explicit shadows and color win over the theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NeuButton(
            shadows: [customShadow],
            color: Colors.green,
            child: Text('explicit'),
          ),
          extensions: const [
            NeuTheme(keyShadows: [], keyBackgroundColor: Colors.red),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeuButton);
      expect(decoration.boxShadow, const [customShadow]);
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(NeuButton),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, Colors.green);
    });

    testWidgets('falls back to the default neu shadows without a theme', (
      tester,
    ) async {
      await tester.pumpWidget(host(const NeuButton(child: Text('plain'))));

      final decoration = outerDecoration(tester, NeuButton);
      expect(decoration.boxShadow, NeuTheme.defaultKeyShadows);
    });
  });

  group('NeuContainer', () {
    testWidgets('applies theme shadows, background and radius', (tester) async {
      await tester.pumpWidget(
        host(
          const NeuContainer(child: Text('box')),
          extensions: const [
            NeuTheme(
              keyShadows: [customShadow],
              keyBackgroundColor: Colors.red,
              borderRadius: 8,
            ),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeuContainer);
      expect(decoration.boxShadow, const [customShadow]);
      expect(decoration.color, Colors.red);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('restores the default neu shadows without a theme', (
      tester,
    ) async {
      await tester.pumpWidget(host(const NeuContainer(child: Text('box'))));

      final decoration = outerDecoration(tester, NeuContainer);
      expect(decoration.boxShadow, NeuTheme.defaultKeyShadows);
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });
  });

  testWidgets('GradientText renders a ShaderMask around the text', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const GradientText(
          'gradient',
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
      ),
    );

    expect(find.byType(ShaderMask), findsOneWidget);
    expect(find.text('gradient'), findsOneWidget);
  });

  testWidgets('AppFlatButton invokes its callback and renders its child', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(AppFlatButton(onTap: () => taps++, child: const Text('flat'))),
    );

    expect(find.text('flat'), findsOneWidget);
    await tester.tap(find.byType(AppFlatButton));
    expect(taps, 1);
  });

  testWidgets('Indicator renders its label and value', (tester) async {
    await tester.pumpWidget(
      host(const Indicator(color: Colors.red, text: 'Label', isSquare: true)),
    );

    expect(find.text('Label'), findsOneWidget);
    final decoration = outerDecoration(tester, Indicator);
    expect(decoration.shape, BoxShape.rectangle);
    expect(decoration.color, Colors.red);
  });

  testWidgets('AnimatedListItem builds its child through the intro animation', (
    tester,
  ) async {
    await tester.pumpWidget(host(const AnimatedListItem(child: Text('item'))));

    expect(find.text('item'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('item'), findsOneWidget);
  });

  testWidgets('PercentSwitch reports the selected percentage', (tester) async {
    final selected = <double>[];
    await tester.pumpWidget(host(PercentSwitch(changePercent: selected.add)));

    expect(find.byType(FittedBox), findsNWidgets(4));

    await tester.tap(find.text('25 %'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(selected, [0.25]);
  });

  testWidgets('TimeRangeSwitch reports the selected range', (tester) async {
    final selected = <TimeRangeSwitchValue>[];
    await tester.pumpWidget(host(TimeRangeSwitch(changeTime: selected.add)));

    expect(find.byType(FittedBox), findsNWidgets(4));

    await tester.tap(find.text('1W'));
    await tester.pumpAndSettle();

    expect(selected, [TimeRangeSwitchValue.week]);
  });

  testWidgets('PriceBadge renders a formatted positive percentage', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(PriceBadge(percentage: Decimal.parse('12.5'))),
    );

    expect(find.text('+12.50%'), findsOneWidget);
    expect(find.byType(FittedBox), findsOneWidget);
  });

  testWidgets('PriceBadge renders a formatted negative percentage', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(PriceBadge(percentage: Decimal.parse('-3.25'))),
    );

    expect(find.text('-3.25%'), findsOneWidget);
  });

  testWidgets('DropdownMenuIcon opens and selects an item', (tester) async {
    final selections = <String>[];
    var selectedIndex = -1;
    await tester.pumpWidget(
      host(
        DropdownMenuIcon<String>(
          currentIndex: -1,
          items: const [
            DropdownItem<String>(value: 'first', child: Text('First')),
            DropdownItem<String>(value: 'second', child: Text('Second')),
          ],
          onChange: (value, index) {
            selections.add(value);
            selectedIndex = index;
          },
          child: const Text('choose'),
        ),
      ),
    );

    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);

    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();

    expect(selections, ['second']);
    expect(selectedIndex, 1);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('slideUpRoute builds the given page when pushed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(slideUpRoute(const Text('routed page'))),
              child: const Text('go'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('routed page'), findsOneWidget);
  });
}
