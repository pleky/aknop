import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/resources/pages/form_survey_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/detail_survey_controller.dart';

class DetailSurveyPage extends NyStatefulWidget<DetailSurveyController> {
  static RouteView path = ("/detail-survey", (_) => DetailSurveyPage());

  DetailSurveyPage({super.key}) : super(child: () => _DetailSurveyPageState());
}

class _DetailSurveyPageState extends NyState<DetailSurveyPage> {
  /// [DetailSurveyController] controller
  DetailSurveyController get controller => widget.controller;
  DetailModel? _detail;

  @override
  get init => () async {
        await api<TransactionApiService>(
          (request) => request.detailSurvey(widget.data()),
          onSuccess: (response, data) {
            setState(() {
              _detail = DetailModel.fromJson(data['data']);
            });
          },
        );
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          )
        ],
        title: const Text("Detail Survey"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text('Judul Survey :').displaySmall().setFontSize(14),
              Text(_detail?.stepOne?.judul ?? '').bodyMedium().setFontSize(14),
              Text('Wilayah Sungai :').displaySmall().setFontSize(14),
              Text('${_detail?.stepOne?.latitude}, ${_detail?.stepOne?.longitude}').bodyMedium().setFontSize(14),
              Text('Sungai :').displaySmall().setFontSize(14),
              Text('${_detail?.stepOne?.vSungai}').bodyMedium().setFontSize(14),
              Text('AKNOP :').displaySmall().setFontSize(14),
              Text('${_detail?.stepOne?.vJenisAknop}').bodyMedium().setFontSize(14),
              Text('Sarana Prasarana :').displaySmall().setFontSize(14),
              Text('${_detail?.stepOne?.vJenisSarpra}').bodyMedium().setFontSize(14),
              Text('Pelaksana :').displaySmall().setFontSize(14),
              Text('${_detail?.stepOne?.vPelaksana}').bodyMedium().setFontSize(14),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Lanjutkan Survey').titleMedium(color: Colors.black, fontWeight: FontWeight.w600),
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return Color(0xFF61eabc);
                  }), side: WidgetStateBorderSide.resolveWith(
                    (states) {
                      return BorderSide(color: Color(0xFF61eabc));
                    },
                  )),
                  onPressed: () {
                    routeTo(FormSurveyPage.path, data: _detail?.stepOne?.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
