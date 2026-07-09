import 'package:flutter_test/flutter_test.dart';
import 'package:resq_meal/config/production_config.dart';

void main() {
  test('production config exposes app metadata', () {
    expect(ProductionConfig.appDisplayName, 'ResQ Meal');
    expect(ProductionConfig.androidApplicationId, 'com.resqmeal.resq_meal');
  });

  test('validateForProduction reports missing FlutterFire when placeholders remain', () {
    final issues = ProductionConfig.validateForProduction();
    if (!ProductionConfig.isFirebaseConfigured) {
      expect(issues, isNotEmpty);
      expect(issues.first, contains('flutterfire configure'));
    } else {
      expect(issues, isEmpty);
    }
  });
}
