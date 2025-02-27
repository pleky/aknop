import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/app/utils/formatter.dart';
import 'package:flutter_app/resources/pages/survey_list_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/summary_controller.dart';

class SummaryPage extends NyStatefulWidget<SummaryController> {
  static RouteView path = ("/summary", (_) => SummaryPage());

  SummaryPage({super.key}) : super(child: () => _SummaryPageState());
}

class _SummaryPageState extends NyState<SummaryPage> {
  /// [SummaryController] controller
  SummaryController get controller => widget.controller;
  DetailModel? _detail;

  @override
  LoadingStyle get loadingStyle => LoadingStyle.skeletonizer();

  @override
  get init => () async {
        await api<TransactionApiService>(
          (request) => request.detailSurvey(widget.data()),
          onSuccess: (response, data) {
            DetailModel _res = DetailModel.fromJson(data['data']);
            setState(() {
              _detail = _res;
            });
          },
        );
      };

  Widget _renderDetailStepTwo() {
    if (_detail == null) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _detail!.stepTwo!.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IDENTIFIKASI KEGIATAN ${i + 1} :').headingSmall(),
              Text('Bangunan Yang Di Amati : '),
              Text(_detail?.stepTwo![i].bagianBangunan ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Upload Bukti Masalah : '),
              for (var j = 0; j < _detail!.stepTwo![i].buktiSurvey!.length; j++)
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    _detail!.stepTwo![i].buktiSurvey![j],
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Placeholder();
                    },
                  ),
                ),
              SizedBox(height: 16),
              Text('Judul Masalah : '),
              Text(_detail?.stepTwo![i].masalah ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Tindakan yang Diperlukan : '),
              Text(_detail?.stepTwo![i].tindakan ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Kondisi Fungsi : '),
              Text(_detail?.stepTwo![i].vKondisiFungsi ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Kondisi Fisik : '),
              Text(_detail?.stepTwo![i].vKondisiFisik ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget _renderDetailStepThree() {
    if (_detail == null) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _detail!.stepThree!.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PENENTUAN NILAI ${i + 1} :').headingSmall(),
              Text('Bangunan Yang Di Amati : '),
              Text(_detail?.stepThree![i].vTigaBagianBangunan ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('HSP : '),
              Text(_detail?.stepThree![i].vTigaHsp ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              for (var j = 0; j < _detail!.stepThree![i].vTigaSubHsp!.length; j++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_detail?.stepThree?[i].vTigaSubHsp?[j] ?? ''),
                    Text(CurrencyFormat.convertToIdr(int.parse(_detail!.stepThree![i].tigaHasil![j].toString()), 0))
                        .bodyMedium(fontWeight: FontWeight.w600),
                    SizedBox(height: 16),
                    Text(_detail?.stepThree![i].tigaSatuan![j] ?? ''),
                    Text(CurrencyFormat.convertToIdr(
                            int.parse(_detail!.stepThree![i].tigaHasil![j]) /
                                int.parse(_detail!.stepThree![i].tigaVolume![j]),
                            0))
                        .bodyMedium(fontWeight: FontWeight.w600),
                    SizedBox(height: 16),
                  ],
                )
            ],
          ),
      ],
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () {
            pop();
          },
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_detail?.stepOne?.judul ?? '').titleLarge(),
              SizedBox(height: 16),
              Text('Longitude: '),
              Text(_detail?.stepOne?.longitude ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Latitude:'),
              Text(_detail?.stepOne?.latitude ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Wilayah Sungai:'),
              Text(_detail?.stepOne?.vWsungai ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Sungai:'),
              Text(_detail?.stepOne?.vSungai ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('AKNOP :'),
              Text(_detail?.stepOne?.vJenisAknop ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Sarana Prasarana : '),
              Text(_detail?.stepOne?.vJenisSarpra ?? '').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              _renderDetailStepTwo(),
              _renderDetailStepThree(),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Simpan'),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade300;
                      }

                      return Color(0xFF61eabc);
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade500;
                      }

                      return Colors.black;
                    }),
                    side: WidgetStateBorderSide.resolveWith(
                      (states) {
                        WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Colors.grey.shade300;
                          }

                          return BorderSide(color: Colors.black);
                        });
                      },
                    ),
                  ),
                  onPressed: () {
                    routeTo(SurveyListPage.path, navigationType: NavigationType.pushAndForgetAll);

                    // reboot();
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
