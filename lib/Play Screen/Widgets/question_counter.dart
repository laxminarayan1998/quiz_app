import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';

class QuestionCounter extends StatelessWidget {
  final AuthController authController = Get.find();
  final PlayController playController = Get.find();

  QuestionCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 32,
          color: const Color(0xff969696),
        ),
        children: [
          TextSpan(
            text: 'Q',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'uestion ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '${authController.currentQuestionPosition.value + 1}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '/${authController.user.value.questionLists!.length}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
