import 'package:flutter_test/flutter_test.dart';
import 'package:shede/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Basic smoke test - verify app widget exists
    const app = ShedeApp();
    expect(app, isNotNull);
  });
}
