import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/survey_form.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:flutter_app/resources/pages/drawing_map_page.dart';
import 'package:flutter_app/resources/pages/identifikasi_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/form_survey_controller.dart';

class FormSurveyPage extends NyStatefulWidget<FormSurveyController> {
  static RouteView path = ("/form-survey", (_) => FormSurveyPage());

  FormSurveyPage({super.key}) : super(child: () => _FormSurveyPageState());
}

class _FormSurveyPageState extends NyState<FormSurveyPage> {
  /// [FormSurveyController] controller
  FormSurveyController get controller => widget.controller;

  final TextEditingController wSungaiController = TextEditingController();
  final TextEditingController sungaiController = TextEditingController();
  final TextEditingController aknopController = TextEditingController();
  final TextEditingController sarpraController = TextEditingController();

  List<SelectedListItem<Base>> wilayahSungai = [];
  List<SelectedListItem<Base>> sungai = [];
  List<SelectedListItem<Base>> aknop = [];
  List<SelectedListItem<Base>> sarpra = [];

  @override
  String? get stateName => 'sungai_state';

  int test = 0;

  @override
  get init => () async {
        await api<MasterApiService>(
          (request) => request.getAllWilayahSungai(),
          onSuccess: (response, data) {
            List<Base> _wSungai = data;
            List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
              _wSungai.map((e) => SelectedListItem(data: e)),
            );
            setState(() {
              wilayahSungai = selectedItems;
            });
          },
        );

        await api<MasterApiService>(
          (request) => request.getAllAknop(),
          onSuccess: (response, data) {
            List<Base> _res = data;
            List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
              _res.map((e) => SelectedListItem(data: e)),
            );
            setState(() {
              aknop = selectedItems;
            });
          },
        );
      };

  Future<void> getListSungai(int id) async {
    await api<MasterApiService>(
      (request) => request.getAllSungai(id),
      onSuccess: (response, data) {
        List<Base> _res = data;
        List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
          _res.map((e) => SelectedListItem(data: e)),
        );
        setState(() {
          sungai = selectedItems;
        });
      },
    );
  }

  Future<void> getListSarpra(int id) async {
    await api<MasterApiService>(
      (request) => request.getAllSarpra(id),
      onSuccess: (response, data) {
        List<Base> _res = data;
        List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
          _res.map((e) => SelectedListItem(data: e)),
        );
        setState(() {
          sarpra = selectedItems;
        });
      },
    );
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          backgroundColor: Color(0xFFe0e0e0),
          value: 0.3,
        ),
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
          child: FormBuilder(
            autovalidateMode: AutovalidateMode.onUnfocus,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Center(child: Text(' Survey Infra / Sungai').headingMedium().alignCenter()),
                Text('Judul Survey'),
                FormBuilderTextField(
                  name: "judul",
                  maxLines: 3,
                  validator: FormBuilderValidators.required(errorText: 'Judul Survey tidak boleh kosong'),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                Text('Lokasi Saat Ini'),
                FormBuilderField<List<List<double>>>(
                  name: 'lokasi',
                  validator: FormBuilderValidators.required(errorText: 'Lokasi tidak boleh kosong'),
                  builder: (field) {
                    return TextField(
                      onTap: () {
                        routeTo(
                          DrawingMapPage.path,
                          data: field.value,
                          result: true,
                          onPop: (value) {
                            if (value != null) {
                              print(value);
                              _formKey.currentState?.fields['lokasi']?.didChange(value);
                            }
                          },
                        );
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        suffixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                        ),
                        hintText: 'Tandai Lokasi',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        error: field.errorText != null
                            ? Text(field.errorText ?? '').setStyle(TextStyle(color: Colors.red, fontSize: 12))
                            : null,
                      ),
                    );
                  },
                ),
                Text('WSungai'),
                MyDropdownField(
                  controller: wSungaiController,
                  dataDropdown: wilayahSungai,
                  name: 'wSungai',
                  errorText: 'Wilayah Sungai tidak boleh kosong',
                  enable: true,
                  placeholder: 'Pilih Wilayah Sungai',
                  onSelected: (item) {
                    sungaiController.clear();
                    setState(() {
                      sungai = [];
                    });
                    getListSungai(item.data.id!);
                  },
                ),
                Text('Sungai'),
                MyDropdownField(
                  controller: sungaiController,
                  dataDropdown: sungai,
                  name: 'sungai',
                  placeholder: 'Pilih Sungai',
                  enable: sungai.isNotEmpty,
                  errorText: 'Sungai tidak boleh kosong',
                  onSelected: (item) {},
                ),
                Text('AKNOP'),
                MyDropdownField(
                  controller: aknopController,
                  dataDropdown: aknop,
                  errorText: 'Aknop tidak boleh kosong',
                  name: 'aknop',
                  placeholder: 'Aknop',
                  enable: true,
                  onSelected: (item) {
                    sarpraController.clear();
                    setState(() {
                      sarpra = [];
                    });
                    getListSarpra(item.data.id!);
                  },
                ),
                Text('Sarana Prasarana'),
                MyDropdownField(
                  errorText: 'Sarpra tidak boleh kosong',
                  controller: sarpraController,
                  dataDropdown: sarpra,
                  name: 'sarpra',
                  placeholder: 'Pilih Sarpra',
                  enable: sarpra.isNotEmpty,
                  onSelected: (item) {},
                ),
                Text('Tahun Pelaksanaan'),
                FormBuilderDateTimePicker(
                  name: 'year',
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  format: DateFormat('yyyy'),
                  // initialEntryMode: DatePickerEntryMode.input,
                  initialDatePickerMode: DatePickerMode.year,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: Text('Simpan').titleMedium(color: Colors.black, fontWeight: FontWeight.w600),
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) {
                      return Color(0xFF61eabc);
                    }), side: WidgetStateBorderSide.resolveWith(
                      (states) {
                        return BorderSide(color: Color(0xFF61eabc));
                      },
                    )),
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();
                      if (_formKey.currentState?.validate() ?? false) {
                        final data = _formKey.currentState!.value;
                        final payload = {
                          'title': 'Tambah',
                          'step': 1,
                          'survey': data['judul'],
                          'wsungai': data['wSungai'].data.id,
                          'sungai': data['sungai'].data.id,
                          'aknop': data['aknop'].data.id,
                          'sarpra': data['sarpra'].data.id,
                          'currentLocation': '${data['lokasi'][0][0]},${data['lokasi'][0][1]}',
                          // 'currentLocation': "-8.0364839,112.6571827",
                          'polygon': jsonEncode({'coordinates': data['lokasi']}),
                          'year': data['year'].toString().substring(0, 4),
                        };
                        debugPrint("payload =>>>>>>>> $payload");

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(30),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );

                        await api<TransactionApiService>(
                          (request) => request.saveStep1(payload),
                          onSuccess: (response, data) {
                            pop();
                            routeTo(IdentifikasiPage.path);
                          },
                          onError: (dioException) {
                            pop();
                            showToastDanger(description: 'Gagal menyimpan data');
                          },
                        );

                        // routeTo(SurveyListPage.path, navigationType: NavigationType.pushReplace);
                      }
                      //
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
