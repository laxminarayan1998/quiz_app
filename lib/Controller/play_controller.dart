import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/Controller/auth_controller.dart';
import 'package:quiz_app/Dashboard%20Screen/dashboard_screen.dart';
import 'package:quiz_app/Model/question.dart';
import 'package:quiz_app/enum/Answer.dart';

class PlayController extends GetxController {
  final AuthController authController = Get.find();
  final databaseReference = FirebaseFirestore.instance;

  var celebritiesList = <Question>[].obs;

  var isOptionClicked = false.obs;

  Future<void> getQuestionFromApi() async {
    final url = Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=26&type=multiple');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      celebritiesList.clear();
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final celebrities = jsonResponse['results'] as List;

      celebrities.forEach(
        (celeb) {
          celebritiesList.add(Question.fromJson(celeb));
        },
      );

      if (authController.user.value.questionLists!.length == 0) {
        databaseReference
            .collection('Users')
            .doc(authController.user.value.id)
            .update(
          {
            'gameQuestions': celebritiesList
                .map(
                  (element) => {
                    'question': element.question,
                    'incorrect_answers': element.options,
                    'correct_answer': element.answer,
                    'result': 'NOT PLAYED',
                  },
                )
                .toList(),
          },
        );

        celebrities.forEach(
          (celeb) {
            authController.user.value.questionLists!.add(
              {
                'question': celeb['question'],
                'correct_answer': celeb['correct_answer'],
                'incorrect_answers':
                    [...celeb['incorrect_answers'], celeb['correct_answer']]
                        .map(
                          (e) => {
                            'option': e,
                            'status': '',
                          },
                        )
                        .toList(),
                'result': 'NOT PLAYED',
              },
            );
          },
        );
        authController.user.value.questionLists!.forEach((element) {
          List list = element['incorrect_answers'];
          list.shuffle();
        });
      }
    }
  }

  Future<void> writeQuestionsDataInDb(Answer answer) async {
    await databaseReference
        .collection('Users')
        .doc(authController.user.value.id)
        .update(
      {
        'currentScore': answer == Answer.Correct
            ? (authController.currentQuestionPosition.value !=
                    authController.user.value.questionLists!.length - 1)
                ? FieldValue.increment(1)
                : FieldValue.increment(0)
            : FieldValue.increment(0),
        'lastQuestionPosition':
            authController.currentQuestionPosition.value + 1,
      },
    ).then(
      (value) => {
        authController.user.value.currentScore = answer == Answer.Correct
            ? authController.user.value.currentScore! + 1
            : authController.user.value.currentScore!,
        isOptionClicked.value = false,
        authController.currentQuestionPosition.value =
            (authController.currentQuestionPosition.value !=
                    authController.user.value.questionLists!.length - 1)
                ? authController.currentQuestionPosition.value + 1
                : authController.currentQuestionPosition.value,
        authController.user.refresh(),
      },
    );
  }

  Future<void> resetUserGame() async {
    await databaseReference
        .collection('Users')
        .doc(authController.user.value.id)
        .update(
      {
        'scoreHistory': FieldValue.arrayUnion(
          [
            {
              'score': authController.user.value.currentScore,
              'timestamp': DateTime.now(),
            }
          ],
        )
      },
    );

    await databaseReference
        .collection('Users')
        .doc(authController.user.value.id)
        .update(
      {
        'currentScore': 0,
        'lastQuestionPosition': 0,
        'gameQuestions': [],
      },
    ).then(
      (value) => {
        isOptionClicked.value = false,
        authController.user.value.currentScore = 0,
        authController.currentQuestionPosition.value = 0,
        authController.user.value.questionLists!.clear(),
        authController.user.refresh(),
      },
    );
  }
}
