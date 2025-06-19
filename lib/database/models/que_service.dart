import 'que_model.dart';

class QuestionService {
  static Future<List<Question>> fetchQuestionsForDay(int day) async {
    int start = (day - 1) * 20;
    int end = start + 20;

    List<Question> dummy = List.generate(200, (index) {
      return Question(
        id: index,
        text: "Question ${index + 1} from DB",
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        answerIndex: index % 4,
      );
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    return dummy.sublist(start, end);
  }
}
