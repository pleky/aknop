import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/detail.dart';
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

  Future<Map<String, dynamic>?> saveStep1(Map<String, dynamic> data) async {
    return await network<Map<String, dynamic>>(
      request: (api) => api.post('/transaction/survey/step-one', data: data),
    );
  }

  Future<Map<String, dynamic>?> saveStep2(Map<String, dynamic> data) async {
    return await network<Map<String, dynamic>>(
      request: (api) => api.post('/transaction/survey/step-two', data: data),
    );
  }

  Future<Map<String, dynamic>?> saveStep3(List<dynamic> data) async {
    return await network<Map<String, dynamic>>(
      request: (api) => api.post('/transaction/survey/step-three', data: data),
    );
  }

  Future<Map<String, dynamic>?> detailSurvey(dynamic id) async {
    return await network<Map<String, dynamic>>(
      request: (api) => api.get('/transaction/survey/detail/$id'),
    );
  }

  Future<Map<String, dynamic>?> upload(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({"dokumen": await MultipartFile.fromFile(file.path, filename: fileName)});
    return await network<Map<String, dynamic>>(
      request: (api) => api.post('/transaction/upload/file', data: formData),
    );
  }
}
