class Question {
  final String id;
  final String value;
  final List<Response> responses;

  Question({required this.id, required this.value, required this.responses});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      value: json['value'],
      responses: (json['responses'] as List)
          .map((response) => Response.fromJson(response))
          .toList(),
    );
  }
}

class Response {
  final String value;
  final bool correct;

  Response({required this.value, required this.correct});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      value: json['value'],
      correct: json['correct'],
    );
  }
}