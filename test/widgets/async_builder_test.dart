import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reign/widgets/async_builder.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('ReignAsyncBuilder shows loading', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      ReignAsyncBuilder<String>(
        future: () => Future.delayed(const Duration(seconds: 1), () => 'data'),
        builder: (data) => Text(data),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Complete the delayed future
    await tester.pumpAndSettle();
  });

  testWidgets('ReignAsyncBuilder shows error', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      ReignAsyncBuilder<String>(
        future: () => Future.error('test'),
        builder: (data) => Text(data),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('Error: test'), findsOneWidget);
  });

  testWidgets('ReignAsyncBuilder shows data', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      ReignAsyncBuilder<String>(
        future: () => Future.value('success'),
        builder: (data) => Text(data),
      ),
    ));

    await tester.pumpAndSettle();
    expect(find.text('success'), findsOneWidget);
  });
}
