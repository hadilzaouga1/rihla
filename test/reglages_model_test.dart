import 'package:flutter_test/flutter_test.dart';
import 'package:rihla/providers/reglages_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('charge false par défaut et persiste le basculement', () async {
    SharedPreferences.setMockInitialValues({});
    final model = ReglagesModel();
    var notifications = 0;
    model.addListener(() => notifications++);

    await model.charger();
    expect(model.sombre, isFalse);
    expect(notifications, 1);

    await model.basculerTheme();
    expect(model.sombre, isTrue);
    expect(notifications, 2);
    expect(
      (await SharedPreferences.getInstance()).getBool('sombre'),
      isTrue,
    );
  });

  test('charge le thème sombre enregistré', () async {
    SharedPreferences.setMockInitialValues({'sombre': true});
    final model = ReglagesModel();

    await model.charger();

    expect(model.sombre, isTrue);
  });
}
