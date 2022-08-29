import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PunchBagRepository {
  static PunchBagRepository? _instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  static PunchBagRepository getInstance() {
    _instance ??= PunchBagRepository();
    return _instance!;
  }

  Future<String?> getPressureReading() async {
    final prefs = await SharedPreferences.getInstance();

    String? deviceCode = prefs.getString('device');

    DatabaseReference punchPressureRef =
        _database.ref('Device/$deviceCode/Pressure');
    return await punchPressureRef.get().then((data) => data.value.toString());
  }

  registerDevice(String? deviceCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('device', deviceCode!);
  }
}
