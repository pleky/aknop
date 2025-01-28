import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/survey.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TransactionApiService extends NyApiService {
  TransactionApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<Survey>?> getAllSurvey() async {
    return await network<List<Survey>>(
      request: (api) => api.get('/transaction/survey/all'),
    );
  }

  Future<Survey?> getSurvey(String id) async {
    return await network<Survey>(
      request: (api) => api.get('/transaction/survey/$id'),
    );
  }

  Future<Survey?> saveStep1(Map<String, dynamic> data) async {
    return await network<Survey>(
      request: (api) => api.post('/transaction/survey/step-one', data: data),
    );
  }
}
