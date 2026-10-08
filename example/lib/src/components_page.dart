import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  static const List<String> _pairs = ['ETH/USDT', 'BTC/USDT', 'SOL/USDT'];

  double _stake = 0.5;
  TimeRangeSwitchValue _range = TimeRangeSwitchValue.day;
  String _pair = 'ETH/USDT';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          const Text(
            'atomic_ui_kit',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Domain-free Flutter widgets.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 26),

          const SectionTitle('Neu & flat buttons'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              NeuButton(
                width: 132,
                height: 52,
                onTap: () {},
                child: const Text(
                  'Buy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              NeuButton(
                width: 168,
                height: 52,
                gradient: accentGradient,
                onTap: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Launch',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              AppFlatButton(
                width: 148,
                height: 52,
                radius: 16,
                borderColor: accentColor,
                onTap: () {},
                child: const Text(
                  'Withdraw',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),

          const SectionTitle('Neu containers & gradient text'),
          Row(
            children: [
              Expanded(
                child: NeuContainer(
                  height: 116,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Portfolio',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        const GradientText(
                          '12 480.25',
                          gradient: accentGradient,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const NeuContainer(
                width: 116,
                height: 116,
                child: Icon(Icons.bolt, color: accentColor, size: 34),
              ),
            ],
          ),
          const SizedBox(height: 26),

          const SectionTitle('Percent switch'),
          NeuContainer(
            height: 84,
            width: double.infinity,
            child: Center(
              child: PercentSwitch(
                width: 84,
                onChanged: (value) => setState(() => _stake = value),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stake: ${(_stake * 100).round()} %',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 22),

          const SectionTitle('Time range switch'),
          NeuContainer(
            height: 84,
            width: double.infinity,
            child: Center(
              child: TimeRangeSwitch(
                color: accentColor,
                onChanged: (value) => setState(() => _range = value),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Range: ${_range.name}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 22),

          const SectionTitle('Price badge & indicator'),
          Row(
            children: [
              PriceBadge(percentage: Decimal.parse('12.34')),
              const SizedBox(width: 10),
              PriceBadge(percentage: Decimal.parse('-3.25')),
              const SizedBox(width: 18),
              const Indicator(
                color: accentColor,
                text: 'Buy',
                isSquare: false,
                size: 12,
                textColor: Colors.white70,
              ),
              const SizedBox(width: 14),
              const Indicator(
                color: dangerColor,
                text: 'Sell',
                isSquare: true,
                size: 12,
                textColor: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 26),

          const SectionTitle('Dropdown menu icon'),
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownMenuIcon<String>(
              currentIndex: _pairs.indexOf(_pair),
              items: [
                for (final pair in _pairs)
                  DropdownItem<String>(value: pair, child: _PairLabel(pair)),
              ],
              dropdownStyle: const DropdownStyle(
                color: Color(0xFF2B3852),
                elevation: 8,
                borderRadius: BorderRadius.all(Radius.circular(14)),
                padding: EdgeInsets.symmetric(vertical: 4),
              ),
              dropdownButtonStyle: const DropdownButtonStyle(
                backgroundColor: keyColor,
                primaryColor: Colors.white,
                height: 48,
                width: 176,
                padding: EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),
              onChange: (value, index) => setState(() => _pair = value),
              child: const Text('Select pair'),
            ),
          ),
          const SizedBox(height: 26),

          const SectionTitle('Animated list item'),
          for (final position in _positions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedListItem(
                height: 68,
                width: double.infinity,
                child: PositionTile(
                  symbol: position.$1,
                  name: position.$2,
                  price: position.$3,
                  change: position.$4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PairLabel extends StatelessWidget {
  const _PairLabel(this.pair);

  final String pair;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(pair, style: const TextStyle(fontSize: 14)),
    );
  }
}

final List<(String, String, String, Decimal)> _positions = [
  ('BTC', 'Bitcoin', '64 210.50', Decimal.parse('0.82')),
  ('ETH', 'Ethereum', '2 384.10', Decimal.parse('4.18')),
  ('SOL', 'Solana', '148.62', Decimal.parse('-1.27')),
];
