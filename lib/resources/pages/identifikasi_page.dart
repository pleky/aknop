import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/identifikasi_form.dart';
import 'package:flutter_app/resources/pages/penentuan_nilai_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';

class IdentifikasiPage extends NyStatefulWidget {
  static RouteView path = ("/identifikasi", (_) => IdentifikasiPage());

  IdentifikasiPage({super.key}) : super(child: () => _IdentifikasiPageState());
}

class _IdentifikasiPageState extends NyPage<IdentifikasiPage> {
  @override
  get init => () {};

  final form = IdentifikasiForm();

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
            Text('Form Identifikasi Masalah').titleLarge(),
            NyForm(
              form: form,
              footer: Column(
                children: [
                  SizedBox(height: 16),
                  Button.primary(text: 'Tambahkan Masalah'),
                ],
              ),
            ),
            Spacer(),
            Button.rounded(
              text: 'Simpan Data',
              onPressed: () {
                routeTo(PenentuanNilaiPage.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
