import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/base_navigation_hub.dart';
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

  @override
  get init => () {};

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
              Text('Proyek Sungai Mushi').titleLarge(),
              SizedBox(height: 16),
              Text('Lokasi: '),
              Text('Suka Bumi').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Kategori :'),
              Text('Sungai').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Kondisi Fisik : '),
              Text('40 (Cukup Baik)').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Kondisi Fungsi : '),
              Text('40 (Cukup Baik)').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Tindakan yang Diperlukan:'),
              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ')
                  .bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Taksiran Volume :'),
              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ')
                  .bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Bukti Survey :'),
              Image.asset(
                getImageAsset('logo.png'),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text('Peta Lokasi:'),
              Image.asset(
                getImageAsset('logo.png'),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text('Identifikasi Masalah : '),
              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit,').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('Penentuan Nilai: '),
              Image.asset(
                getImageAsset('logo.png'),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text('Volume Penentuan Nilai :'),
              Text('5% (0,05)').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Text('HSP :'),
              Text('COD Meter (Chemical Oxygen Demand)').bodyMedium(fontWeight: FontWeight.w600),
              SizedBox(height: 16),
              Button.primary(
                text: 'Simpan Perhitungan',
                onPressed: () {
                  routeTo(SurveyListPage.path, navigationType: NavigationType.pushAndForgetAll);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
