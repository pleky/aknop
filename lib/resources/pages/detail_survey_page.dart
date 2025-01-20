import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/detail_survey_controller.dart';

class DetailSurveyPage extends NyStatefulWidget<DetailSurveyController> {
  static RouteView path = ("/detail-survey", (_) => DetailSurveyPage());

  DetailSurveyPage({super.key}) : super(child: () => _DetailSurveyPageState());
}

class _DetailSurveyPageState extends NyState<DetailSurveyPage> {
  /// [DetailSurveyController] controller
  DetailSurveyController get controller => widget.controller;

  @override
  get init => () {};

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
              Text('PENCEMARAN SUNGAI BRANTAS').bodyMedium().setFontSize(14),
              Text('Wilayah Sungai :').displaySmall().setFontSize(14),
              Text('-123123, 123123').bodyMedium().setFontSize(14),
              Text('Sungai :').displaySmall().setFontSize(14),
              Text('Kali Solo').bodyMedium().setFontSize(14),
              Text('AKNOP :').displaySmall().setFontSize(14),
              Text('SUNGAI').bodyMedium().setFontSize(14),
              Text('Sarana Prasarana :').displaySmall().setFontSize(14),
              Text('Sungai Alami').bodyMedium().setFontSize(14),
              Text('Pelaksana :').displaySmall().setFontSize(14),
              Text('Superadmin').bodyMedium().setFontSize(14),
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
