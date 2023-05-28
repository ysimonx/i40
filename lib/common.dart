import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

Future<String?> getClientCloudToken() async {
  // Create storage

// Read value
  var key = "token";
  String? value =
      await secureStorage.read(key: key, aOptions: _getAndroidOptions());

  return value;
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
      // sharedPreferencesName: 'Test2',
      // preferencesKeyPrefix: 'Test'
    );
