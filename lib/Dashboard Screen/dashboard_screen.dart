import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Controller/result_controller.dart';
import 'package:quiz_app/Play%20Screen/play_screen.dart';
import 'package:quiz_app/enum/utils.dart';

import '../constants.dart';
import '../main_button.dart';

class DashboardScreen extends StatelessWidget {
  final ResultController resultController = Get.put(ResultController());
  final PlayController playController = Get.find();
  final AuthController authController = Get.find();

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
                print(authController.user.value.isPlaying);
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

class ScoreBoard extends StatelessWidget {
  final List? scores;
  const ScoreBoard({
    Key? key,
    this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SCORE HISTORY (${scores!.length})',
              style: TextStyle(
                fontSize: 12,
                color: kSubTextColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: defaultPadding),
            ...List.generate(
              scores!.length,
              (index) => ScoreWidget(
                index: index + 1,
                score: scores![index]['score'],
                time: scores![index]['timestamp'],
              ),
            ).toList().reversed
          ],
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  final int? index;
  final int? score;
  final Timestamp? time;
  const ScoreWidget({
    Key? key,
    this.score,
    this.time,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27.0),
        color: kTextColorLight.withOpacity(.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x06ffffff),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$index.',
            style: TextStyle(
              fontSize: 16,
              color: kSubTextColorLight,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$score Points',
            style: TextStyle(
              fontSize: 16,
              color: kTextColorLight,
            ),
          ),
          Spacer(),
          Text(
            '${DateFormat('dd MMM').format(DateTime.parse(time!.toDate().toString()))}',
            style: TextStyle(
              fontSize: 16,
              color: kTextColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
