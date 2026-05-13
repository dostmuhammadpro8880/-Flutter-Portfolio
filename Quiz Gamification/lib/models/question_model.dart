// class QuizQuestion {
//   final String question;
//   final List<String> options;
//   final List<String> images;
//   final String audioPath;
//   final String correctAnswer;

//   QuizQuestion(
//     this.question,
//     this.options,
//     this.images,
//     this.audioPath,
//     this.correctAnswer,
//   );
// }

class QuizQuestion {
  final String question;
  final List<String> options;
  final List<String> images;
  final String audioPath;
  final String correctAnswer;

  QuizQuestion(
    this.question,
    this.options,
    this.images,
    this.audioPath,
    this.correctAnswer,
  );
}



class Products {
  int id;
  String title;

  Products(this.id, this.title);
}

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}
