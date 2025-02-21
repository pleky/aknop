import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/auth.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthApiService extends NyApiService {
  AuthApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<AuthModel?> login(String email, String password) async {
    return await network<AuthModel>(
      request: (api) => api.post('/loginpost', data: {'email': email, 'password': password}),
      handleSuccess: (response) {
        final dynamic data = response.data['data'];
        return AuthModel.fromJson(data);
      },
      receiveTimeout: Duration(seconds: 30),
    );
  }
}
