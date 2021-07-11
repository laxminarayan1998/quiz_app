class Question {
  String? question;
  List? options;
  String? answer;
  String? result;

  Question({this.question, this.options, this.answer, this.result});

  Question.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['incorrect_answers'];
    answer = json['correct_answer'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['options'] = this.options;
    data['answer'] = this.answer;
    data['result'] = this.result;
    return data;
  }
}
