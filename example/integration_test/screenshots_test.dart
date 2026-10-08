import 'package:atomic_ui_kit_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture pub.dev screenshot', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await binding.takeScreenshot('components');
  });
}
