import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'atomic_ui_kit example',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: const Color(0xFF1E2638),
        extensions: const [
          NeuTheme(keyBackgroundColor: Color(0xFF252F45), borderRadius: 12),
        ],
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  static const double _pagePadding = 24;

  double _percent = 0.5;
  TimeRangeSwitchValue _range = TimeRangeSwitchValue.week;

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.sizeOf(context).width - _pagePadding * 2;
    return Scaffold(
      appBar: AppBar(title: const Text('atomic_ui_kit example')),
      body: ListView(
        padding: const EdgeInsets.all(_pagePadding),
        children: [
          NeuButton(
            height: 56,
            width: double.infinity,
            semanticLabel: 'Buy',
            onTap: () {},
            child: const Text('Buy'),
          ),
          const SizedBox(height: 24),
          const NeuContainer(
            height: 80,
            width: double.infinity,
            child: Center(child: Text('NeuContainer')),
          ),
          const SizedBox(height: 24),
          Text('Percent: ${(_percent * 100).round()} %'),
          PercentSwitch(
            width: availableWidth / 4,
            onChanged: (percent) => setState(() => _percent = percent),
          ),
          const SizedBox(height: 24),
          Text('Range: ${_range.name}'),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: TimeRangeSwitch(
              onChanged: (range) => setState(() => _range = range),
            ),
          ),
          const SizedBox(height: 24),
          Center(child: PriceBadge(percentage: Decimal.parse('12.34'))),
        ],
      ),
    );
  }
}
