import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Controller/result_controller.dart';
import 'package:quiz_app/main_button.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController =
      Get.put(AuthController(), permanent: true);
  final PlayController playController =
      Get.put(PlayController(), permanent: true);
  final ResultController resultController =
      Get.put(ResultController(), permanent: true);

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.asset('assets/svg/logo.svg'),
            ),
            SizedBox(
              width: Get.width * .8,
              child: DefaultButton(
                text: 'LOG IN WITH GOOGLE',
                onPress: () {
                  authController.signInWithGoogle();
                  // Get.to(() => DashboardScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
