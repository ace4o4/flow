import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgeflow/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ForgeFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify the app title is present
    expect(find.text('ForgeFlow'), findsOneWidget);
  });
}
