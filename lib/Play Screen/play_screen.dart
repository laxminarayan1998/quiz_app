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

import 'Widgets/option_widget.dart';
import 'Widgets/question.dart';
import 'Widgets/question_counter.dart';

class PlayScreen extends StatefulWidget {
  PlayScreen({Key? key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with WidgetsBindingObserver {
  final PlayController playController = Get.find();
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _notification = state;
    });
    if (state == AppLifecycleState.paused) {
      await playController.setIfUserIsPlaying(false);
    } else if (state == AppLifecycleState.resumed) {
      await playController.setIfUserIsPlaying(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_notification);
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
      body: WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want pause the game'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    await playController.setIfUserIsPlaying(false);
                    Get.off(() => DashboardScreen());
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: FutureBuilder(
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
                                authController
                                    .currentQuestionPosition.value]['question'],
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
                              isCorrect:
                                  authController.user.value.questionLists![
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
                                                  .currentQuestionPosition
                                                  .value]['incorrect_answers']
                                          [index]['option'];

                                  if (correctAns == selectedAns) {
                                    authController.user.value.questionLists![
                                        authController.currentQuestionPosition
                                            .value]['result'] = 'CORRECT';

                                    authController.user.value.questionLists![
                                            authController
                                                .currentQuestionPosition
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
                                            authController
                                                .currentQuestionPosition
                                                .value]['incorrect_answers']
                                        [index]['status'] = 'WRONG';

                                    authController.user.value.questionLists![
                                        authController.currentQuestionPosition
                                            .value]['result'] = 'WRONG';

                                    List list = authController
                                            .user.value.questionLists![
                                        authController.currentQuestionPosition
                                            .value]['incorrect_answers'];

                                    int correctAnsIndex = list.indexWhere(
                                        (element) =>
                                            element['option'] == correctAns);

                                    authController.user.value.questionLists![
                                            authController
                                                .currentQuestionPosition
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
                                  print('################');
                                  print(
                                      'Before Click Position ${authController.currentQuestionPosition}');
                                  print(
                                      'Question Length ${authController.user.value.questionLists!.length}');

                                  if (authController
                                          .currentQuestionPosition.value <
                                      authController.user.value.questionLists!
                                              .length -
                                          1) {
                                    if (authController
                                                .user.value.questionLists![
                                            authController
                                                .currentQuestionPosition
                                                .value]['result'] !=
                                        'NOT PLAYED') {
                                      await playController
                                          .writeQuestionsDataInDb(
                                        authController.user.value
                                                        .questionLists![
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
                                    if (authController
                                                .user.value.questionLists![
                                            authController
                                                .currentQuestionPosition
                                                .value]['result'] !=
                                        'NOT PLAYED') {
                                      await playController
                                          .writeLastQuestionInDb(
                                        authController.user.value
                                                        .questionLists![
                                                    authController
                                                        .currentQuestionPosition
                                                        .value]['result'] ==
                                                'CORRECT'
                                            ? Answer.Correct
                                            : Answer.Wrong,
                                      );

                                      playController.setIfUserIsPlaying(false);
                                      Get.offAll(() => ResultScreen());
                                      await playController.resetUserGame();
                                    } else {
                                      Utility.showToast(
                                          msg: 'Please select an option');
                                    }
                                  }

                                  print(
                                      'After Click Position ${authController.currentQuestionPosition}');
                                  print('################');
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
      ),
    );
  }
}
