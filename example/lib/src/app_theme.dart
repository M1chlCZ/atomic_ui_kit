import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

const Color canvasColor = Color(0xFF1E2638);
const Color keyColor = Color(0xFF252F45);
const Color accentColor = Color(0xFF9BD41E);
const Color tealColor = Color(0xFF35D0BA);
const Color dangerColor = Color(0xFFF35656);

const LinearGradient accentGradient = LinearGradient(
  colors: [accentColor, tealColor],
);

const List<BoxShadow> neuShadows = [
  BoxShadow(color: Color(0x14FFFFFF), offset: Offset(-4, -4), blurRadius: 12),
  BoxShadow(color: Color(0x73000000), offset: Offset(4, 4), blurRadius: 12),
];

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    canvasColor: canvasColor,
    scaffoldBackgroundColor: canvasColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: tealColor,
      surface: keyColor,
      error: dangerColor,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: keyColor,
      indicatorColor: accentColor.withValues(alpha: 0.16),
      elevation: 0,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    extensions: const [
      NeuTheme(
        keyBackgroundColor: keyColor,
        borderRadius: 16,
        keyShadows: neuShadows,
      ),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class PositionTile extends StatelessWidget {
  const PositionTile({
    super.key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  final String symbol;
  final String name;
  final String price;
  final Decimal change;

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      height: 68,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PriceBadge(percentage: change),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
