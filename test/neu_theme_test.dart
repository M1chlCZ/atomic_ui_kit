import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const BoxShadow _shadowA = BoxShadow(
  offset: Offset(1, 1),
  blurRadius: 2,
  color: Color(0xFF010101),
);

const BoxShadow _shadowB = BoxShadow(
  offset: Offset(-1, -1),
  blurRadius: 3,
  color: Color(0xFF020202),
);

void main() {
  group('NeuTheme', () {
    test('defaults match the documented neu shadows and radius', () {
      const theme = NeuTheme();
      expect(theme.keyShadows, hasLength(2));
      expect(
        theme.keyShadows.first,
        const BoxShadow(
          offset: Offset(-1, -1),
          blurRadius: 4,
          color: Color.fromRGBO(134, 134, 134, 0.05),
        ),
      );
      expect(
        theme.keyShadows.last,
        const BoxShadow(
          offset: Offset(1, 1),
          blurRadius: 4,
          color: Color.fromRGBO(2, 2, 2, 0.25),
        ),
      );
      expect(theme.keyBackgroundColor, isNull);
      expect(theme.borderRadius, 4.0);
      expect(theme.keyShadows, NeuTheme.defaultKeyShadows);
    });

    test('copyWith replaces values and can clear the background color', () {
      const original = NeuTheme(
        keyShadows: [_shadowA],
        keyBackgroundColor: Colors.red,
        borderRadius: 12,
      );

      final copy = original.copyWith(
        keyShadows: const [_shadowB],
        keyBackgroundColor: Colors.blue,
        borderRadius: 8,
      );
      expect(copy.keyShadows, const [_shadowB]);
      expect(copy.keyBackgroundColor, Colors.blue);
      expect(copy.borderRadius, 8);

      final untouched = original.copyWith();
      expect(untouched.keyShadows, const [_shadowA]);
      expect(untouched.keyBackgroundColor, Colors.red);
      expect(untouched.borderRadius, 12);

      final cleared = original.copyWith(keyBackgroundColor: null);
      expect(cleared.keyBackgroundColor, isNull);
      expect(cleared.keyShadows, const [_shadowA]);
    });

    test('equality is structural and hashes equal shadow lists', () {
      const a = NeuTheme(keyShadows: [_shadowA], borderRadius: 6);
      const b = NeuTheme(keyShadows: [_shadowA], borderRadius: 6);
      const c = NeuTheme(keyShadows: [_shadowB], borderRadius: 6);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a, isNot(NeuTheme(keyShadows: [_shadowA], borderRadius: 7)));
    });

    test('lerp interpolates shadows, color and radius', () {
      const a = NeuTheme(
        keyShadows: [_shadowA],
        keyBackgroundColor: Colors.black,
        borderRadius: 0,
      );
      const b = NeuTheme(
        keyShadows: [_shadowB],
        keyBackgroundColor: Colors.white,
        borderRadius: 10,
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.borderRadius, 5);
      expect(
        mid.keyBackgroundColor,
        Color.lerp(Colors.black, Colors.white, 0.5),
      );
      expect(
        mid.keyShadows.first.color,
        Color.lerp(_shadowA.color, _shadowB.color, 0.5),
      );
      expect(mid.keyShadows, hasLength(1));
      expect(a.lerp(null, 0.5), a);
    });
  });
}
