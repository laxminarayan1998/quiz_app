import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:quiz_app/Auth%20Screen/login_screen.dart';
import 'package:quiz_app/Play%20Screen/play_screen.dart';
import 'package:quiz_app/Result%20Screen/result_screen.dart';
import 'package:quiz_app/Splash%20Screen/splash_screen.dart';
import 'package:quiz_app/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      home: SplashScreen(),
    );
  }
}
