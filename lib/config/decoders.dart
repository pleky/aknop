import 'package:flutter_app/app/controllers/summary_controller.dart';
import 'package:flutter_app/app/models/detail.dart';

import '/app/models/hsp.dart';
import '/app/models/survey.dart';
import 'package:flutter_app/app/controllers/detail_survey_controller.dart';
import 'package:flutter_app/app/controllers/drawing_map_controller.dart';
import 'package:flutter_app/app/controllers/form_survey_controller.dart';
import 'package:flutter_app/app/controllers/landing_controller.dart';
import 'package:flutter_app/app/controllers/penentuan_nilai_controller.dart';
import 'package:flutter_app/app/controllers/survey_list_controller.dart';

import '/app/networking/master_api_service.dart';
import '/app/models/base.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/user.dart';
import '/app/models/detail.dart';
import '/app/networking/api_service.dart';
import '/app/networking/transaction_api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/6.x/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  Map<String, dynamic>: (data) => Map<String, dynamic>.from(data),

  List<User>: (data) => List.from(data).map((json) => User.fromJson(json)).toList(),
  //
  User: (data) => User.fromJson(data),

  List<Base>: (data) => List.from(data).map((json) => Base.fromJson(json)).toList(),

  Base: (data) => Base.fromJson(data),

  List<Hsp>: (data) => List.from(data).map((json) => Hsp.fromJson(json)).toList(),

  Hsp: (data) => Hsp.fromJson(data),

  List<Survey>: (data) => List.from(data['data']).map((json) => Survey.fromJson(json)).toList(),

  Survey: (data) => Survey.fromJson(data),
  String: (data) => data,
  DetailModel: (data) => DetailModel.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/6.x/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...

  MasterApiService: MasterApiService(),
  TransactionApiService: () => TransactionApiService()
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/6.x/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),
  LandingController: () => LandingController(),
  SurveyListController: () => SurveyListController(),
  FormSurveyController: () => FormSurveyController(),
  DrawingMapController: () => DrawingMapController(),
  DetailSurveyController: () => DetailSurveyController(),
  PenentuanNilaiController: () => PenentuanNilaiController(),
  SummaryController: () => SummaryController(),
  // ...
};
