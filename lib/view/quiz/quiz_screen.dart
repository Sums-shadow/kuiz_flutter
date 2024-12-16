import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/api_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questionsData = await _apiService.getQuestions();
      setState(() {
        _questions = questionsData.map((q) => Question.fromJson(q)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load questions. Please try again.')),
      );
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('No questions available.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _questions[_currentQuestionIndex].value,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      ..._questions[_currentQuestionIndex].responses.map((response) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _nextQuestion();
                            },
                            child: Text(response.value),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
    );
  }
}