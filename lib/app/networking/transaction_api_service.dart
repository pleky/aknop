import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/models/home.dart';
import 'package:flutter_app/app/models/survey.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TransactionApiService extends NyApiService {
  TransactionApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<Survey>?> getAllSurvey({String? title}) async {
    String url = "/transaction/survey/all";
    if (title != null && title != '') {
      url += "?title=$title";
    }

    return await network<List<Survey>>(
      request: (api) => api.get(url),
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

  Future<String?> upload(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({"dokumen": await MultipartFile.fromFile(file.path, filename: fileName)});
    return await network<String>(
      request: (api) => api.post('/transaction/upload/file', data: formData),
      handleSuccess: (response) => response.data['data'],
    );
  }

  Future<HomeModel?> getHomeData(String id) async {
    return await network<HomeModel>(
      request: (api) => api.get('/homepage/$id'),
      handleSuccess: (response) {
        final dynamic data = response.data;
        return HomeModel.fromJson(data);
      },
    );
  }
}
