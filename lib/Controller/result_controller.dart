import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class ResultController extends GetxController {
  final AuthController authController = Get.find();
  final databaseReference = FirebaseFirestore.instance;

  var scoreList = [].obs;

  Future<void> getScores() async {
    scoreList.clear();
    await databaseReference
        .collection('Users')
        .doc(authController.user.value.id)
        .get()
        .then(
          (value) => {
            (value['scoreHistory'] as List).forEach(
              (e) => {
                scoreList.add(
                  {
                    "score": e['score'],
                    "timestamp": e['timestamp'],
                  },
                ),
              },
            ),
            scoreList.refresh(),
          },
        );
  }
}
