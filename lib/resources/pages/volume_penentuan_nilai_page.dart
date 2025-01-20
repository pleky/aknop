import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/volume_penentuan_nilai_form.dart';
import 'package:flutter_app/resources/pages/summary_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/volume_penentuan_nilai_controller.dart';

class VolumePenentuanNilaiPage extends NyStatefulWidget<VolumePenentuanNilaiController> {
  static RouteView path = ("/volume-penentuan-nilai", (_) => VolumePenentuanNilaiPage());

  VolumePenentuanNilaiPage({super.key}) : super(child: () => _VolumePenentuanNilaiPageState());
}

class _VolumePenentuanNilaiPageState extends NyState<VolumePenentuanNilaiPage> {
  /// [VolumePenentuanNilaiController] controller
  VolumePenentuanNilaiController get controller => widget.controller;

  @override
  get init => () {};

  final form = VolumePenentuanNilaiForm();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Volume Penentuan Nilai').titleLarge(),
            SizedBox(height: 16),
            NyForm(form: form),
            Spacer(),
            Button.rounded(
              text: 'Simpan Perhitungan',
              onPressed: () {
                routeTo(SummaryPage.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}
