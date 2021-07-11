import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Dashboard%20Screen/dashboard_screen.dart';
import 'package:quiz_app/Result%20Screen/result_screen.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/enum/Answer.dart';
import 'package:quiz_app/enum/utils.dart';
import 'package:quiz_app/main_button.dart';
import 'package:quiz_app/size_config.dart';

class PlayScreen extends StatelessWidget {
  final PlayController playController = Get.find();
  final AuthController authController = Get.find();

  PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
          'QUIZ APP',
          style: TextStyle(
            color: kTextColorLight,
            fontSize: 14,
          ),
        ),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 12,
                  color: kTextColorLight,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: playController.getQuestionFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Obx(
            () => Column(
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(
                      begin: 0,
                      end: authController.currentQuestionPosition.value *
                          (1 / 10)),
                  duration: Duration(milliseconds: 300),
                  builder: (context, double value, child) =>
                      LinearProgressIndicator(
                    backgroundColor: kSubTextColorLight.withOpacity(.4),
                    valueColor: AlwaysStoppedAnimation<Color>(yellowColor),
                    value: value,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        QuestionCounter(),
                        Divider(
                          color: kTextColorLight.withOpacity(.4),
                        ),
                        Spacer(),
                        Question(
                          question: authController.user.value.questionLists![
                                  authController.currentQuestionPosition.value]
                              ['question'],
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        ...List.generate(
                          authController
                              .user
                              .value
                              .questionLists![authController
                                  .currentQuestionPosition
                                  .value]['incorrect_answers']
                              .length,
                          (index) => OptionWidget(
                            isCorrect: authController.user.value.questionLists![
                                    authController
                                        .currentQuestionPosition.value]
                                ['incorrect_answers'][index]['status'],
                            onPress: () {
                              if (!playController.isOptionClicked.value) {
                                final correctAns =
                                    authController.user.value.questionLists![
                                        authController.currentQuestionPosition
                                            .value]['correct_answer'];

                                final selectedAns =
                                    authController.user.value.questionLists![
                                            authController
                                                .currentQuestionPosition.value]
                                        ['incorrect_answers'][index]['option'];

                                if (correctAns == selectedAns) {
                                  authController.user.value.questionLists![
                                      authController.currentQuestionPosition
                                          .value]['result'] = 'CORRECT';

                                  authController.user.value.questionLists![
                                          authController.currentQuestionPosition
                                              .value]['incorrect_answers']
                                      [index]['status'] = 'CORRECT';

                                  authController.user.value.questionLists![
                                      authController.currentQuestionPosition
                                          .value]['result'] = 'CORRECT';
                                } else {
                                  authController.user.value.questionLists![
                                      authController.currentQuestionPosition
                                          .value]['result'] = 'WRONG';

                                  authController.user.value.questionLists![
                                          authController.currentQuestionPosition
                                              .value]['incorrect_answers']
                                      [index]['status'] = 'WRONG';

                                  authController.user.value.questionLists![
                                      authController.currentQuestionPosition
                                          .value]['result'] = 'WRONG';

                                  List list =
                                      authController.user.value.questionLists![
                                          authController.currentQuestionPosition
                                              .value]['incorrect_answers'];

                                  int correctAnsIndex = list.indexWhere(
                                      (element) =>
                                          element['option'] == correctAns);

                                  authController.user.value.questionLists![
                                          authController.currentQuestionPosition
                                              .value]['incorrect_answers']
                                      [correctAnsIndex]['status'] = 'CORRECT';
                                }

                                authController.user.refresh();
                              }

                              playController.isOptionClicked.value = true;
                            },
                            text: authController.user.value.questionLists![
                                    authController
                                        .currentQuestionPosition.value]
                                ['incorrect_answers'][index]['option'],
                          ),
                        ),
                        SizedBox(height: defaultPadding * 2),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: Get.width * .4,
                            child: DefaultButton(
                              text: 'NEXT',
                              onPress: () async {
                                if (authController
                                        .currentQuestionPosition.value <
                                    authController
                                            .user.value.questionLists!.length -
                                        1) {
                                  if (authController.user.value.questionLists![
                                          authController.currentQuestionPosition
                                              .value]['result'] !=
                                      'NOT PLAYED') {
                                    await playController.writeQuestionsDataInDb(
                                      authController.user.value.questionLists![
                                                  authController
                                                      .currentQuestionPosition
                                                      .value]['result'] ==
                                              'CORRECT'
                                          ? Answer.Correct
                                          : Answer.Wrong,
                                    );
                                  } else {
                                    Utility.showToast(
                                        msg: 'Please select an option');
                                  }
                                } else {
                                  Get.offAll(() => ResultScreen());
                                  await playController.resetUserGame();
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Question extends StatelessWidget {
  final String? question;
  Question({
    Key? key,
    this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$question',
      style: TextStyle(
        fontSize: getProportionateScreenWidth(22),
        color: kTextColorLight,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

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

class OptionWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  final String? text;
  final Function()? onPress;
  final String? isCorrect;
  OptionWidget({
    Key? key,
    this.text,
    this.onPress,
    this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: defaultPadding),
        padding: EdgeInsets.symmetric(
            vertical: defaultPadding / 1.2, horizontal: defaultPadding * 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 2.0,
            color: isCorrect! == ''
                ? mainColor.withOpacity(.6)
                : isCorrect! == 'CORRECT'
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        child: Row(
          children: [
            Text(
              '$text',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                color: kTextColorLight,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(defaultPadding / 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: mainColor,
                border: Border.all(
                  width: 2.0,
                  color: mainColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
