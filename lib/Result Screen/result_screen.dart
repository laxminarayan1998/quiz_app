import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Dashboard%20Screen/dashboard_screen.dart';
import 'package:quiz_app/main_button.dart';

import '../constants.dart';

class ResultScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 5),
      () => Get.offAll(() => DashboardScreen()),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'RESULT',
          style: TextStyle(
            color: kTextColorLight,
            fontSize: 14,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: Get.width - defaultPadding * 2,
              height: Get.height * .6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(33.0),
                color: kTextColorLight.withOpacity(.3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    authController.user.value.currentScore! > 5
                        ? 'assets/svg/Icon ionic-ios-happy.svg'
                        : 'assets/svg/Icon awesome-sad-cry.svg',
                  ),
                  SizedBox(height: defaultPadding),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        color: const Color(0xfffcfcfc),
                      ),
                      children: [
                        TextSpan(
                          text: 'S',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'core',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '${authController.user.value.currentScore}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '/10',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '*Please wait you will be automatically redirected to home page.',
                    style: TextStyle(
                      fontSize: 10,
                      color: kTextColorLight.withOpacity(.7),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            // SizedBox(
            //   width: Get.width * .4,
            //   child: DefaultButton(
            //     text: 'HOME',
            //     onPress: () {},
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
