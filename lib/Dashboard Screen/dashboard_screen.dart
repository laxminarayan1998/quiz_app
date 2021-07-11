import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Play%20Screen/play_screen.dart';

import '../constants.dart';
import '../main_button.dart';

class DashboardScreen extends StatelessWidget {
  final PlayController playController = Get.find();

  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: playController.getQuestionFromApi(),
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
                child: ScoreBoard(),
              )
            ],
          ),
        );
      },
    ));
  }
}

class PlayBoard extends StatelessWidget {
  const PlayBoard({
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
          child: DefaultButton(
            text: 'PLAY',
            onPress: () {
              Get.to(() => PlayScreen());
            },
          ),
        ),
      ],
    );
  }
}

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    Key? key,
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
              'SCORE HISTORY (10)',
              style: TextStyle(
                fontSize: 12,
                color: kSubTextColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: defaultPadding),
            ...List.generate(
              7,
              (index) => ScoreWidget(),
            ).toList()
          ],
        ),
      ),
    );
  }
}

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({
    Key? key,
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
            '1.',
            style: TextStyle(
              fontSize: 16,
              color: kSubTextColorLight,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '8 Points',
            style: TextStyle(
              fontSize: 16,
              color: kTextColorLight,
            ),
          ),
          Spacer(),
          Text(
            '12 Jul',
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
