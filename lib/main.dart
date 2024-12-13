//References for this final project: Course website, youtube, google, stackoverflow, flutter.dev, in class exercises, tutorials, and professor shoaib's assistance.
import 'package:flutter/material.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'screens/welcome_screen.dart';
import 'utils/theme.dart';

String? deviceId;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  deviceId = await getDeviceId();
  runApp(const MovieNightApp());
}

Future<String> getDeviceId() async {
  try {
    // For Android
    final androidId = const AndroidId();
    final id = await androidId.getId();
    if (id != null) return id;

    // For ios
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'unknown_device';
  } catch (e) {
    debugPrint('Error fetching device ID: $e');
    return 'unknown_device';
  }
}

class MovieNightApp extends StatelessWidget {
  const MovieNightApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Night',
      theme: appTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
