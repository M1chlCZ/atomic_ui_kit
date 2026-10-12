import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtomicTheme.light', () {
    test('uses a pale base color and a bright top-left shadow', () {
      final theme = AtomicTheme.light();
      expect(theme.baseColor, const Color(0xFFE9EDF4));
      expect(theme.lightShadow!.a, 0.85);
      expect(theme.darkShadow!.a, 0.32);
      expect(theme.radius, 16);
      expect(theme.depth, AtomicTheme.defaultDepth);
    });

    test('keeps explicit shadow colors', () {
      final theme = AtomicTheme.light(
        lightShadow: const Color(0xFFFFFFFF),
        darkShadow: const Color(0xFF000000),
      );
      expect(theme.lightShadow, const Color(0xFFFFFFFF));
      expect(theme.darkShadow, const Color(0xFF000000));
    });

    test('derives the shadows from a custom base color', () {
      final theme = AtomicTheme.light(baseColor: const Color(0xFFDDE7FF));
      expect(theme.lightShadow, isNot(AtomicTheme.light().lightShadow));
      expect(theme.lightShadow!.computeLuminance(), greaterThan(0.5));
    });
  });

  group('AtomicTheme.dark', () {
    test('uses a deep base color and a faint top-left highlight', () {
      final theme = AtomicTheme.dark();
      expect(theme.lightShadow!.a, 0.10);
      expect(theme.darkShadow!.a, 0.55);
    });

    test('uses a darker base color than the light preset', () {
      expect(
        AtomicTheme.dark().baseColor!.computeLuminance(),
        lessThan(AtomicTheme.light().baseColor!.computeLuminance()),
      );
    });

    test('passes the depth and radius through', () {
      final theme = AtomicTheme.dark(depth: 2, radius: 24);
      expect(theme.depth, 2);
      expect(theme.radius, 24);
      expect(theme.buildShadows().first.blurRadius, 8);
    });
  });
}
