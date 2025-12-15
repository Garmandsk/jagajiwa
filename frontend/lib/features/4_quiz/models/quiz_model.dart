class QuizModel {
  final String question;
  final List<String>? options;
  final bool isNumberPicker;
  final bool isTextInput;
  final String? image;

  QuizModel({
    required this.question,
    this.options,
    this.isNumberPicker = false,
    this.isTextInput = false,
    this.image,
  });
}
