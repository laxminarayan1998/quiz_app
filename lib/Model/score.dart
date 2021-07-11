class Score {
  int? score;
  String? timestamp;

  Score({this.score, this.timestamp});

  Score.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
