import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class TradingPage extends StatefulWidget {
  const TradingPage({super.key});

  @override
  State<TradingPage> createState() => _TradingPageState();
}

class _TradingPageState extends State<TradingPage> {
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
          Row(
            children: [
              const Text(
                'Rocketbot',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              DropdownMenuIcon<String>(
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
                  height: 44,
                  width: 150,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                onChange: (value, index) => setState(() => _pair = value),
                child: const Text('Select pair'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          NeuContainer(
            height: 164,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Portfolio value',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const GradientText(
                    '12 480.25 USDT',
                    gradient: accentGradient,
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      PriceBadge(percentage: Decimal.parse('12.34')),
                      const SizedBox(width: 10),
                      const Text(
                        '+1 342.18 today',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text(
                'Performance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                'Last ${_range.name}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeuContainer(
            height: 88,
            width: double.infinity,
            child: Center(
              child: TimeRangeSwitch(
                color: accentColor,
                onChanged: (value) => setState(() => _range = value),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('Open positions'),
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
          const SizedBox(height: 10),
          const SectionTitle('Buy'),
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
          const SizedBox(height: 18),
          NeuButton(
            height: 56,
            width: double.infinity,
            gradient: accentGradient,
            onTap: () => Navigator.of(
              context,
            ).push(slideUpRoute(BuySheet(pair: _pair, stake: _stake))),
            child: Text(
              'Buy ${_pair.split('/').first}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class BuySheet extends StatefulWidget {
  const BuySheet({super.key, required this.pair, required this.stake});

  final String pair;
  final double stake;

  @override
  State<BuySheet> createState() => _BuySheetState();
}

class _BuySheetState extends State<BuySheet> {
  late double _stake = widget.stake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Buy ${widget.pair}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  AppFlatButton(
                    radius: 12,
                    icon: const Icon(Icons.close, size: 20),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              NeuContainer(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const _SummaryRow(label: 'Amount', value: '1.500 ETH'),
                      const SizedBox(height: 14),
                      const _SummaryRow(
                        label: 'Price',
                        value: '2 384.10 USDT',
                      ),
                      const SizedBox(height: 14),
                      _SummaryRow(
                        label: 'Stake',
                        value: '${(_stake * 100).round()} %',
                      ),
                      const SizedBox(height: 14),
                      const _SummaryRow(label: 'Fee', value: '7.15 USDT'),
                      const Divider(height: 34, color: Colors.white12),
                      const _SummaryRow(
                        label: 'Total',
                        value: '3 576.15 USDT',
                        emphasise: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
              const Spacer(),
              NeuButton(
                height: 56,
                width: double.infinity,
                gradient: accentGradient,
                onTap: () => Navigator.of(context).pop(),
                child: const Text(
                  'Confirm order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              AppFlatButton(
                width: double.infinity,
                height: 52,
                radius: 16,
                onTap: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasise ? 16 : 14,
            fontWeight: emphasise ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
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
