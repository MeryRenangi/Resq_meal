import 'package:flutter_test/flutter_test.dart';
import 'package:resq_meal/app.dart';
import 'package:resq_meal/constants/auth_strings.dart';
import 'package:resq_meal/constants/onboarding_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App loads and shows auth flow for new users', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQMealApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 2));

    final onSplash = find.text('ResQ Meal');
    final onOnboarding = find.text(OnboardingData.pages.first.title);

    expect(onSplash.evaluate().isNotEmpty || onOnboarding.evaluate().isNotEmpty, isTrue);

    if (onOnboarding.evaluate().isNotEmpty) {
      expect(find.text(AuthStrings.onboardingSkip), findsOneWidget);
    }
  });
}
