class Question {
  final int id;
  final String text;
  final List<String> options;
  final int answerIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.answerIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      options: List<String>.from(map['options']),
      answerIndex: map['answerIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'answerIndex': answerIndex,
    };
  }
}
