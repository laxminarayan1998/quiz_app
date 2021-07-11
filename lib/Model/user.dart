import 'package:quiz_app/Model/question.dart';

import 'Score.dart';

class AppUser {
  String? email;
  String? name;
  String? id;
  bool? isPlaying;
  bool? isGamePaused;
  List? questionLists;
  int? lastQuestionPosition;
  List? scoreHistory;
  int? currentScore;

  AppUser({
    this.email,
    this.id,
    this.isPlaying,
    this.isGamePaused,
    this.questionLists,
    this.lastQuestionPosition,
    this.name,
    this.scoreHistory,
    this.currentScore,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    isPlaying = json['isPlaying'];
    isGamePaused = json['isGamePaused'];
    currentScore = json['currentScore'];
    name = json['name'];
    if (json['gameQuestions'] != null) {
      questionLists = <Question>[];
      json['gameQuestions'].forEach((v) {
        questionLists!.add(new Question.fromJson(v));
      });
    }
    lastQuestionPosition = json['lastQuestionPosition'];
    if (json['scoreHistory'] != null) {
      scoreHistory = <Score>[];
      json['scoreHistory'].forEach((v) {
        scoreHistory!.add(new Score.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['isPlaying'] = this.isPlaying;
    data['isGamePaused'] = this.isGamePaused;
    data['currentScore'] = this.currentScore;
    data['name'] = this.name;
    if (this.questionLists != null) {
      data['gameQuestions'] =
          this.questionLists!.map((v) => v.toJson()).toList();
    }
    data['lastQuestionPosition'] = this.lastQuestionPosition;
    if (this.scoreHistory != null) {
      data['scoreHistory'] = this.scoreHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
