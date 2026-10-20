import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

Color materialColor(WidgetTester tester, Type type) {
  return tester
      .widget<Material>(
        find
            .descendant(of: find.byType(type), matching: find.byType(Material))
            .first,
      )
      .color!;
}

void main() {
  group('AtomicTheme', () {
    test('defaults match the previous neu defaults', () {
      const theme = AtomicTheme();

      expect(theme.baseColor, isNull);
      expect(theme.lightShadow, isNull);
      expect(theme.darkShadow, isNull);
      expect(theme.depth, 1.0);
      expect(theme.radius, 4.0);
      expect(
        AtomicTheme.defaultLightShadow,
        const Color.fromRGBO(134, 134, 134, 0.05),
      );
      expect(
        AtomicTheme.defaultDarkShadow,
        const Color.fromRGBO(2, 2, 2, 0.25),
      );
      expect(AtomicTheme.defaultDepth, 1.0);
      expect(AtomicTheme.defaultRadius, 4.0);
    });

    test('buildShadows reproduces the previous default shadows', () {
      const theme = AtomicTheme();

      expect(theme.buildShadows(), NeuTheme.defaultKeyShadows);
    });

    test('buildShadows scales the offset and blur with depth', () {
      const theme = AtomicTheme();

      final shadows = theme.buildShadows(depth: 3);
      expect(shadows, hasLength(2));
      expect(shadows.first.offset, const Offset(-3, -3));
      expect(shadows.first.blurRadius, 12);
      expect(shadows.last.offset, const Offset(3, 3));
      expect(shadows.last.blurRadius, 12);
    });

    test('buildShadows uses the custom shadow colors', () {
      const theme = AtomicTheme(
        lightShadow: Colors.white,
        darkShadow: Colors.black,
      );

      final shadows = theme.buildShadows();
      expect(shadows.first.color, Colors.white);
      expect(shadows.last.color, Colors.black);
    });

    test('copyWith replaces values and clears nullable ones', () {
      const original = AtomicTheme(
        baseColor: Colors.red,
        lightShadow: Colors.white,
        darkShadow: Colors.black,
        depth: 2,
        radius: 12,
      );

      final copy = original.copyWith(
        baseColor: Colors.blue,
        lightShadow: Colors.grey,
        darkShadow: Colors.grey,
        depth: 4,
        radius: 20,
      );
      expect(copy.baseColor, Colors.blue);
      expect(copy.lightShadow, Colors.grey);
      expect(copy.darkShadow, Colors.grey);
      expect(copy.depth, 4);
      expect(copy.radius, 20);

      final cleared = original.copyWith(
        baseColor: null,
        lightShadow: null,
        darkShadow: null,
      );
      expect(cleared.baseColor, isNull);
      expect(cleared.lightShadow, isNull);
      expect(cleared.darkShadow, isNull);
      expect(cleared.depth, 2);
      expect(cleared.radius, 12);

      expect(original.copyWith(), original);
    });

    test('equality is structural and matches hashCode', () {
      const a = AtomicTheme(baseColor: Colors.red, depth: 2, radius: 8);
      const b = AtomicTheme(baseColor: Colors.red, depth: 2, radius: 8);
      const c = AtomicTheme(baseColor: Colors.blue, depth: 2, radius: 8);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(
        a,
        isNot(const AtomicTheme(baseColor: Colors.red, depth: 2, radius: 9)),
      );
    });

    test('lerp interpolates colors, depth and radius', () {
      const a = AtomicTheme(
        baseColor: Colors.black,
        lightShadow: Colors.black,
        darkShadow: Colors.black,
        depth: 0,
        radius: 0,
      );
      const b = AtomicTheme(
        baseColor: Colors.white,
        lightShadow: Colors.white,
        darkShadow: Colors.white,
        depth: 4,
        radius: 10,
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.baseColor, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.lightShadow, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.darkShadow, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.depth, 2);
      expect(mid.radius, 5);
    });

    test('lerp returns this for a null extension', () {
      const theme = AtomicTheme(depth: 2, radius: 6);

      expect(theme.lerp(null, 0.5), theme);
    });

    testWidgets('of returns the extension and falls back to the defaults', (
      tester,
    ) async {
      const theme = AtomicTheme(depth: 3);
      late AtomicTheme registered;
      late AtomicTheme fallback;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              registered = AtomicTheme.of(context);
              return const SizedBox();
            },
          ),
          extensions: const [theme],
        ),
      );
      expect(registered, theme);

      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              fallback = AtomicTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(fallback, const AtomicTheme());
    });

    testWidgets('resolveShadows prefers explicit shadows and NeuTheme', (
      tester,
    ) async {
      const explicit = [BoxShadow(color: Colors.red)];
      const neu = [BoxShadow(color: Colors.green)];
      late List<BoxShadow> explicitResult;
      late List<BoxShadow> neuResult;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              explicitResult = AtomicTheme.resolveShadows(
                context,
                shadows: explicit,
              );
              neuResult = AtomicTheme.resolveShadows(context);
              return const SizedBox();
            },
          ),
          extensions: const [
            NeuTheme(keyShadows: neu),
            AtomicTheme(depth: 4),
          ],
        ),
      );

      expect(explicitResult, explicit);
      expect(neuResult, neu);
    });

    testWidgets('resolveShadows builds from AtomicTheme and explicit depth', (
      tester,
    ) async {
      late List<BoxShadow> themed;
      late List<BoxShadow> deeper;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              themed = AtomicTheme.resolveShadows(context);
              deeper = AtomicTheme.resolveShadows(context, depth: 3);
              return const SizedBox();
            },
          ),
          extensions: const [
            AtomicTheme(
              lightShadow: Colors.white,
              darkShadow: Colors.black,
              depth: 2,
            ),
          ],
        ),
      );

      expect(themed.first.offset, const Offset(-2, -2));
      expect(themed.first.blurRadius, 8);
      expect(themed.first.color, Colors.white);
      expect(themed.last.color, Colors.black);
      expect(deeper.first.offset, const Offset(-3, -3));
      expect(deeper.first.blurRadius, 12);
    });

    testWidgets('resolveShadows returns the built-in defaults', (tester) async {
      late List<BoxShadow> resolved;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              resolved = AtomicTheme.resolveShadows(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolved, NeuTheme.defaultKeyShadows);
    });
  });

  group('theme resolution in widgets', () {
    testWidgets('NeuButton applies AtomicTheme values', (tester) async {
      await tester.pumpWidget(
        host(
          const NeuButton(child: Text('themed')),
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

      final decoration = outerDecoration(tester, NeuButton);
      expect(decoration.borderRadius, BorderRadius.circular(10));
      expect(decoration.boxShadow, const [
        BoxShadow(offset: Offset(-2, -2), blurRadius: 8, color: Colors.white),
        BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: Colors.black),
      ]);
      expect(materialColor(tester, NeuButton), Colors.red);
    });

    testWidgets('NeuButton prefers NeuTheme over AtomicTheme', (tester) async {
      const custom = BoxShadow(color: Colors.green, offset: Offset(5, 5));
      await tester.pumpWidget(
        host(
          const NeuButton(child: Text('themed')),
          extensions: const [
            NeuTheme(
              keyShadows: [custom],
              keyBackgroundColor: Colors.blue,
              borderRadius: 8,
            ),
            AtomicTheme(baseColor: Colors.red, depth: 4, radius: 20),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeuButton);
      expect(decoration.boxShadow, const [custom]);
      expect(decoration.borderRadius, BorderRadius.circular(8));
      expect(materialColor(tester, NeuButton), Colors.blue);
    });

    testWidgets('NeuContainer applies AtomicTheme values', (tester) async {
      await tester.pumpWidget(
        host(
          const NeuContainer(child: Text('box')),
          extensions: const [AtomicTheme(baseColor: Colors.red, radius: 10)],
        ),
      );

      final decoration = outerDecoration(tester, NeuContainer);
      expect(decoration.color, Colors.red);
      expect(decoration.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('NeuContainer prefers NeuTheme over AtomicTheme', (
      tester,
    ) async {
      const custom = BoxShadow(color: Colors.green, offset: Offset(5, 5));
      await tester.pumpWidget(
        host(
          const NeuContainer(child: Text('box')),
          extensions: const [
            NeuTheme(
              keyShadows: [custom],
              keyBackgroundColor: Colors.blue,
              borderRadius: 8,
            ),
            AtomicTheme(baseColor: Colors.red, depth: 4, radius: 20),
          ],
        ),
      );

      final decoration = outerDecoration(tester, NeuContainer);
      expect(decoration.boxShadow, const [custom]);
      expect(decoration.color, Colors.blue);
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });
  });
}
