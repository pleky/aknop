import 'package:flutter_app/app/controllers/detail_survey_controller.dart';
import 'package:flutter_app/app/controllers/drawing_map_controller.dart';
import 'package:flutter_app/app/controllers/form_survey_controller.dart';
import 'package:flutter_app/app/controllers/landing_controller.dart';
import 'package:flutter_app/app/controllers/survey_list_controller.dart';

import '/app/networking/master_api_service.dart';
import '/app/models/base.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/user.dart';
import '/app/networking/api_service.dart';

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
  // ...
};
