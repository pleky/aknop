import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class SurveyListController extends Controller {
  final surveys = [
    {"name": "Survey 1", "date": "2 Mei 2024", "completed": true},
    {"name": "Survey 2", "date": "3 Mei 2024", "completed": false},
    {"name": "Survey 3", "date": "4 Mei 2024", "completed": false},
    {"name": "Survey 4", "date": "5 Mei 2024", "completed": false},
    {"name": "Survey 5", "date": "6 Mei 2024", "completed": true},
    {"name": "Survey 6", "date": "7 Mei 2024", "completed": false},
    {"name": "Survey 7", "date": "8 Mei 2024", "completed": false},
    {"name": "Survey 8", "date": "9 Mei 2024", "completed": true},
    {"name": "Survey 9", "date": "10 Mei 2024", "completed": false},
    {"name": "Survey 10", "date": "11 Mei 2024", "completed": false},
  ];

  @override
  construct(BuildContext context) {
    super.construct(context);
  }
}
