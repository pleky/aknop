import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/volume_penentuan_nilai_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/penentuan_nilai_controller.dart';

class PenentuanNilaiPage extends NyStatefulWidget<PenentuanNilaiController> {
  static RouteView path = ("/penentuan-nilai", (_) => PenentuanNilaiPage());

  PenentuanNilaiPage({super.key}) : super(child: () => _PenentuanNilaiPageState());
}

class _PenentuanNilaiPageState extends NyState<PenentuanNilaiPage> {
  /// [PenentuanNilaiController] controller
  PenentuanNilaiController get controller => widget.controller;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Form Penentuan Nilai').titleLarge(),
            SizedBox(height: 16),
            Button.outlined(
              text: 'Tmbahkan Data Sketsa',
              borderColor: Colors.black,
            ),
            SizedBox(height: 16),
            Text('Hitungan'),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(width: 1),
              ),
            ),
            Spacer(),
            Button.rounded(
              text: 'Simpan Perhitungan',
              onPressed: () {
                routeTo(VolumePenentuanNilaiPage.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
