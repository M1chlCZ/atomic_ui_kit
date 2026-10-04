import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const BoxShadow customShadow = BoxShadow(
  offset: Offset(3, 3),
  blurRadius: 9,
  color: Color(0xFF123456),
);

const List<BoxShadow> sourceDefaultShadows = [
  BoxShadow(
    offset: Offset(-1, -1),
    blurRadius: 4,
    color: Color.fromRGBO(134, 134, 134, 0.05),
  ),
  BoxShadow(
    offset: Offset(1, 1),
    blurRadius: 4,
    color: Color.fromRGBO(2, 2, 2, 0.25),
  ),
];

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
      expect(decoration.boxShadow, sourceDefaultShadows);
      expect(decoration.boxShadow, NeuTheme.defaultKeyShadows);
    });

    testWidgets('exposes a semantic label when one is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const NeuButton(semanticLabel: 'Add funds', child: Text('+'))),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Add funds' &&
              widget.properties.button == true,
        ),
        findsOneWidget,
      );
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
      expect(decoration.boxShadow, sourceDefaultShadows);
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

  group('AppFlatButton', () {
    testWidgets('invokes its callback and renders its child', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(AppFlatButton(onTap: () => taps++, child: const Text('flat'))),
      );

      expect(find.text('flat'), findsOneWidget);
      await tester.tap(find.byType(AppFlatButton));
      expect(taps, 1);
    });

    testWidgets('exposes a semantic label when one is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const AppFlatButton(semanticLabel: 'Dismiss', child: Text('x'))),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Dismiss' &&
              widget.properties.button == true,
        ),
        findsOneWidget,
      );
    });
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

  group('AnimatedListItem', () {
    testWidgets('builds its child through the intro animation', (tester) async {
      await tester.pumpWidget(
        host(const AnimatedListItem(child: Text('item'))),
      );

      expect(find.text('item'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('item'), findsOneWidget);
    });

    testWidgets('defaults to height 100 and full width', (tester) async {
      await tester.pumpWidget(
        host(const AnimatedListItem(child: Text('item'))),
      );

      final sized = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(AnimatedListItem),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sized.height, 100);
      expect(sized.width, 800);
    });

    testWidgets('respects custom height and width', (tester) async {
      await tester.pumpWidget(
        host(
          const AnimatedListItem(height: 160, width: 320, child: Text('item')),
        ),
      );

      final sized = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(AnimatedListItem),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sized.height, 160);
      expect(sized.width, 320);
    });

    testWidgets('settles at scale 1 with the perspective reset', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const AnimatedListItem(child: Text('item'))),
      );
      await tester.pumpAndSettle();

      final transforms = tester
          .widgetList<Transform>(
            find.descendant(
              of: find.byType(AnimatedListItem),
              matching: find.byType(Transform),
            ),
          )
          .toList();
      expect(transforms, hasLength(2));
      expect(transforms.first.transform.entry(3, 1), 0.0);
      expect(transforms.last.transform.getMaxScaleOnAxis(), closeTo(1.0, 1e-9));
    });
  });

  group('PercentSwitch', () {
    testWidgets('reports the selected percentage', (tester) async {
      final selected = <double>[];
      await tester.pumpWidget(host(PercentSwitch(onChanged: selected.add)));

      expect(find.byType(FittedBox), findsNWidgets(4));

      await tester.tap(find.text('25 %'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(selected, [0.25]);
    });

    testWidgets('lays out options with the requested width', (tester) async {
      await tester.pumpWidget(
        host(PercentSwitch(onChanged: (_) {}, width: 80)),
      );

      final boxes = tester
          .widgetList<SizedBox>(
            find.descendant(
              of: find.byType(PercentSwitch),
              matching: find.byType(SizedBox),
            ),
          )
          .toList();
      expect(boxes, hasLength(5));
      expect(boxes.first.width, 320);
      for (final option in boxes.skip(1)) {
        expect(option.width, 80);
      }
    });

    testWidgets('PercentSwitchState.deActivate clears the selection silently', (
      tester,
    ) async {
      final key = GlobalKey<PercentSwitchState>();
      final selected = <double>[];
      await tester.pumpWidget(
        host(PercentSwitch(key: key, onChanged: selected.add)),
      );

      await tester.tap(find.text('25 %'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(selected, [0.25]);

      key.currentState!.deActivate();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(selected, [0.25]);
      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((widget) => widget.opacity);
      expect(opacities, everyElement(0.4));
    });

    testWidgets('deActivate cancels a selection that is still pending', (
      tester,
    ) async {
      final key = GlobalKey<PercentSwitchState>();
      final selected = <double>[];
      await tester.pumpWidget(
        host(PercentSwitch(key: key, onChanged: selected.add)),
      );

      await tester.tap(find.text('50 %'));
      expect(selected, [0.5]);

      key.currentState!.deActivate();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((widget) => widget.opacity);
      expect(opacities, everyElement(0.4));
    });

    testWidgets('does not update after it is disposed', (tester) async {
      await tester.pumpWidget(host(PercentSwitch(onChanged: (_) {})));

      await tester.tap(find.text('25 %'));
      await tester.pumpWidget(host(const SizedBox()));
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
    });
  });

  group('TimeRangeSwitch', () {
    testWidgets('reports the selected range', (tester) async {
      final selected = <TimeRangeSwitchValue>[];
      await tester.pumpWidget(host(TimeRangeSwitch(onChanged: selected.add)));

      expect(find.byType(FittedBox), findsNWidgets(4));

      await tester.tap(find.text('1W'));
      await tester.pumpAndSettle();

      expect(selected, [TimeRangeSwitchValue.week]);
    });

    testWidgets('applies its color to the selected range', (tester) async {
      const highlight = Color(0xFF123456);
      final selected = <TimeRangeSwitchValue>[];
      await tester.pumpWidget(
        host(TimeRangeSwitch(onChanged: selected.add, color: highlight)),
      );

      await tester.tap(find.text('1W'));
      await tester.pumpAndSettle();

      expect(selected, [TimeRangeSwitchValue.week]);
      expect(tester.widget<Text>(find.text('1W')).style!.color, highlight);
      expect(tester.widget<Text>(find.text('1D')).style!.color, Colors.white);
    });

    testWidgets('tolerates a theme without bodyLarge', (tester) async {
      final selected = <TimeRangeSwitchValue>[];
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => Theme(
              data: Theme.of(context).copyWith(textTheme: const TextTheme()),
              child: TimeRangeSwitch(onChanged: selected.add),
            ),
          ),
        ),
      );

      await tester.tap(find.text('1W'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(selected, [TimeRangeSwitchValue.week]);
    });
  });

  group('PriceBadge', () {
    testWidgets('renders a formatted positive percentage', (tester) async {
      await tester.pumpWidget(
        host(PriceBadge(percentage: Decimal.parse('12.5'))),
      );

      expect(find.text('+12.50%'), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);
    });

    testWidgets('renders a formatted negative percentage', (tester) async {
      await tester.pumpWidget(
        host(PriceBadge(percentage: Decimal.parse('-3.25'))),
      );

      expect(find.text('-3.25%'), findsOneWidget);
    });

    testWidgets('updates when the percentage changes on rebuild', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(PriceBadge(percentage: Decimal.parse('12.5'))),
      );
      expect(find.text('+12.50%'), findsOneWidget);

      await tester.pumpWidget(
        host(PriceBadge(percentage: Decimal.parse('-40'))),
      );

      expect(find.text('-40.00%'), findsOneWidget);
      expect(find.text('+12.50%'), findsNothing);
    });
  });

  group('DropdownMenuIcon', () {
    testWidgets('opens and selects an item', (tester) async {
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

    testWidgets('closes on a tap outside without selecting', (tester) async {
      final selections = <String>[];
      await tester.pumpWidget(
        host(
          DropdownMenuIcon<String>(
            currentIndex: -1,
            items: const [
              DropdownItem<String>(value: 'first', child: Text('First')),
              DropdownItem<String>(value: 'second', child: Text('Second')),
            ],
            onChange: (value, index) => selections.add(value),
            child: const Text('choose'),
          ),
        ),
      );

      await tester.tap(find.text('choose'));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsNothing);
      expect(selections, isEmpty);
    });

    testWidgets('can be disposed while open without leaking the overlay', (
      tester,
    ) async {
      var showDropdown = true;
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  rebuild = setState;
                  if (!showDropdown) {
                    return const Text('placeholder');
                  }
                  return DropdownMenuIcon<String>(
                    currentIndex: -1,
                    items: const [
                      DropdownItem<String>(
                        value: 'first',
                        child: Text('First'),
                      ),
                      DropdownItem<String>(
                        value: 'second',
                        child: Text('Second'),
                      ),
                    ],
                    child: const Text('choose'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('choose'));
      await tester.pump(const Duration(milliseconds: 100));

      rebuild(() => showDropdown = false);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsNothing);
      expect(find.text('placeholder'), findsOneWidget);
    });

    testWidgets('selection works without an onChange', (tester) async {
      await tester.pumpWidget(
        host(
          DropdownMenuIcon<String>(
            currentIndex: -1,
            items: const [
              DropdownItem<String>(value: 'first', child: Text('First')),
            ],
            child: const Text('choose'),
          ),
        ),
      );

      await tester.tap(find.text('choose'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('First'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('supports nullable values', (tester) async {
      final selections = <String?>[];
      await tester.pumpWidget(
        host(
          DropdownMenuIcon<String?>(
            currentIndex: -1,
            items: const [
              DropdownItem<String?>(value: null, child: Text('None')),
              DropdownItem<String?>(value: 'one', child: Text('One')),
            ],
            onChange: (value, index) => selections.add(value),
            child: const Text('choose'),
          ),
        ),
      );

      await tester.tap(find.text('choose'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('None'));
      await tester.pumpAndSettle();

      expect(selections, [null]);
    });
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

  test('slideUpRoute keeps the route value type', () {
    expect(slideUpRoute<int>(const Text('page')), isA<Route<int>>());
  });
}
