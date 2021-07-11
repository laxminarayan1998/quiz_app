import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/Controller/play_controller.dart';
import 'package:quiz_app/Dashboard%20Screen/dashboard_screen.dart';
import 'package:quiz_app/Model/question.dart';
import 'package:quiz_app/Model/user.dart';

class AuthController extends GetxController {
  // final PlayController playController = Get.find();
  var user = AppUser().obs;
  final databaseReference = FirebaseFirestore.instance;

  var currentQuestionPosition = 0.obs;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userData =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userData.additionalUserInfo!.isNewUser) {
      user.value = AppUser(
        email: userData.user!.email,
        id: userData.user!.uid,
        name: userData.user!.displayName,
        isGamePaused: false,
        isPlaying: false,
        lastQuestionPosition: 0,
        questionLists: [],
        scoreHistory: [],
        currentScore: 0,
      );

      await writeUserDataInDB(userData.user!).then(
        (value) => {
          Get.to(() => DashboardScreen()),
        },
      );
    } else {
      getUserDataFromDB(userData.user!.uid)
          .then((value) => Get.to(() => DashboardScreen()));
    }

    return userData;
  }

  Future<void> writeUserDataInDB(User data) async {
    await databaseReference.collection('Users').doc(data.uid).set(
      {
        'email': data.email,
        'id': data.uid,
        'name': data.displayName,
        'isPlaying': false,
        'isGamePaused': false,
        'gameQuestions': [],
        'lastQuestionPosition': 0,
        'scoreHistory': [],
        'currentScore': 0,
      },
    );
  }

  Future<void> getUserDataFromDB(String? id) async {
    final userData = await databaseReference.collection('Users').doc(id).get();

    // user.value = AppUser.fromJson(userData.data()!);

    user.value = AppUser(
      email: userData.data()!['email'],
      id: userData.data()!['id'],
      isGamePaused: userData.data()!['isGamePaused'],
      isPlaying: userData.data()!['isPlaying'],
      lastQuestionPosition: userData.data()!['lastQuestionPosition'],
      name: userData.data()!['name'],
      scoreHistory: userData.data()!['scoreHistory'],
      currentScore: userData.data()!['currentScore'],
      questionLists: (userData.data()!['gameQuestions'] as List)
          .map(
            (ques) => {
              'question': ques['question'],
              'correct_answer': ques['correct_answer'],
              'incorrect_answers':
                  [...ques['incorrect_answers'], ques['correct_answer']]
                      .map(
                        (e) => {
                          'option': e,
                          'status': '',
                        },
                      )
                      .toList(),
              'result': ques['result'],
            },
          )
          .toList(),
    );

    user.value.questionLists!.forEach((element) {
      List list = element['incorrect_answers'];
      list.shuffle();
    });

    currentQuestionPosition.value = user.value.lastQuestionPosition!;

    // playController.questionList.value = user.value.questionLists!;

    // playController.questionList.refresh();
  }
}
