import 'package:atomic_ui_kit/atomic_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) {
  return MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('shows the label, the hint and the error text', (tester) async {
    await tester.pumpWidget(
      host(
        const AtomicTextField(
          label: 'Email',
          hint: 'you@example.com',
          errorText: 'Required',
        ),
      ),
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('you@example.com'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('reports text changes and updates the controller', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? changed;
    await tester.pumpWidget(
      host(
        AtomicTextField(
          controller: controller,
          onChanged: (value) => changed = value,
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'hello');
    expect(changed, 'hello');
    expect(controller.text, 'hello');
  });

  testWidgets('masks the text when obscureText is set', (tester) async {
    await tester.pumpWidget(host(const AtomicTextField(obscureText: true)));
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
  });

  testWidgets('grows with maxLines', (tester) async {
    await tester.pumpWidget(host(const AtomicTextField(maxLines: 3)));
    expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 3);
  });

  testWidgets('turns the field off when disabled', (tester) async {
    await tester.pumpWidget(host(const AtomicTextField(enabled: false)));
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('submits the text', (tester) async {
    String? submitted;
    await tester.pumpWidget(
      host(AtomicTextField(onSubmitted: (value) => submitted = value)),
    );
    await tester.enterText(find.byType(TextField), 'ping');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'ping');
  });
}
