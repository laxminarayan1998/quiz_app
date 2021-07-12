import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Play%20Screen/play_screen.dart';
import 'package:quiz_app/enum/utils.dart';

import '../../main_button.dart';

class PlayBoard extends StatelessWidget {
  final AuthController authController = Get.find();
  final PlayController playController = Get.find();
  PlayBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SvgPicture.asset(
          'assets/svg/logo.svg',
          height: Get.height * .2,
        ),
        SizedBox(
          width: Get.width * .8,
          child: Obx(
            () => DefaultButton(
              text: authController.currentQuestionPosition > 0
                  ? 'RESUME'
                  : 'PLAY',
              onPress: () async {
                //? checks if the user is playing. If true then it will restrict the user to play until the ongoing game is finished.
                if (!authController.user.value.isPlaying!) {
                  await playController.setIfUserIsPlaying(true);
                  Get.to(() => PlayScreen());
                } else {
                  Utility.showToast(msg: 'Game is in progress! Please wait.');
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
