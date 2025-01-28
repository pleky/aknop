import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/models/hsp.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MasterApiService extends NyApiService {
  MasterApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  /// Example API Request
  Future<dynamic> fetchData() async {
    return await network(
      request: (request) => request.get("/endpoint-path"),
    );
  }

  Future<List<Base>?> getAllWilayahSungai() async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/wsungai'),
    );
  }

  Future<List<Base>?> getAllSungai(int id) async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/sungai/$id'),
    );
  }

  Future<List<Base>?> getAllAknop() async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/aknop'),
    );
  }

  Future<List<Base>?> getAllSarpra(int id) async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/sarpra/$id'),
    );
  }

  Future<List<Base>?> getAllBagianBangunan() async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/bagian-bangunan/1'),
    );
  }

  Future<List<Base>?> getAllKondisi() async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/kondisi'),
    );
  }

  Future<List<Base>?> getAllSubPekerjaan() async {
    return await network<List<Base>>(
      request: (api) => api.get('/list/sub-pekerjaan'),
    );
  }

  Future<List<Hsp>?> getAllHSP(int id) async {
    return await network<List<Hsp>>(
      request: (api) => api.get('/list/hsp/$id'),
    );
  }
}
