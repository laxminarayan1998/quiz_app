import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Controller/result_controller.dart';

import 'Widgets/play_board.dart';
import 'Widgets/score_board.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final ResultController resultController = Get.find();
  final PlayController playController = Get.find();

  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: resultController.getScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: PlayBoard(),
              ),
              Flexible(
                flex: 2,
                child: ScoreBoard(
                  scores: resultController.scoreList,
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
