import 'dart:convert';

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/resources/pages/drawing_map_page.dart';
import 'package:flutter_app/resources/pages/identifikasi_page.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_app/app/providers/location_provider.dart';
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
  final TextEditingController judulController = TextEditingController();

  List<SelectedListItem<Base>> wilayahSungai = [];
  List<SelectedListItem<Base>> sungai = [];
  List<SelectedListItem<Base>> aknop = [];
  List<SelectedListItem<Base>> sarpra = [];

  @override
  String? get stateName => 'sungai_state';
  DetailModel? detailModel;
  Map<String, dynamic> initialValues = {};

  @override
  LoadingStyle get loadingStyle => LoadingStyle.skeletonizer();

  LocationProvider locationProvider = LocationProvider();

  var _formKey = GlobalKey<FormBuilderState>();

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

        if (widget.data() != 'none') {
          await api<TransactionApiService>(
            (request) => request.detailSurvey(widget.data()),
            onSuccess: (response, data) async {
              if (data['success'] == false) return;
              final DetailModel _detail = DetailModel.fromJson(data['data']);
              final dateFromYear =
                  _detail.stepOne?.year != null ? DateTime.parse('${_detail.stepOne!.year!}-07-20') : DateTime.now();
              if (_detail.stepOne?.polygon != null) {
                final decodedPolygon = jsonDecode(_detail.stepOne?.polygon ?? '');
                if (decodedPolygon['coordinates'] != null) {
                  List<List<double>> polygon =
                      List<List<double>>.from(decodedPolygon['coordinates'].map((e) => List<double>.from(e)));
                  setState(() {
                    detailModel = _detail;
                    initialValues = {
                      'judul': _detail.stepOne!.judul!,
                      'lokasi': polygon,
                      'wSungai': SelectedListItem(
                        data: Base(id: _detail.stepOne!.wsungai, nama: _detail.stepOne!.vWsungai),
                      ),
                      'sungai': SelectedListItem(
                        data: Base(id: _detail.stepOne!.sungai, nama: _detail.stepOne!.vSungai),
                      ),
                      'aknop': SelectedListItem(
                        data: Base(id: _detail.stepOne!.jenisAknop, nama: _detail.stepOne!.vJenisAknop),
                      ),
                      'sarpra': SelectedListItem(
                        data: Base(id: _detail.stepOne!.jenisSarpra, nama: _detail.stepOne!.vJenisSarpra),
                      ),
                      'year': dateFromYear,
                    };
                  });
                } else {
                  setState(() {
                    initialValues = {
                      'judul': _detail.stepOne!.judul!,
                      'wSungai': SelectedListItem(
                        data: Base(id: _detail.stepOne!.wsungai, nama: _detail.stepOne!.vWsungai),
                      ),
                      'sungai': SelectedListItem(
                        data: Base(id: _detail.stepOne!.sungai, nama: _detail.stepOne!.vSungai),
                      ),
                      'aknop': SelectedListItem(
                        data: Base(id: _detail.stepOne!.jenisAknop, nama: _detail.stepOne!.vJenisAknop),
                      ),
                      'sarpra': SelectedListItem(
                        data: Base(id: _detail.stepOne!.jenisSarpra, nama: _detail.stepOne!.vJenisSarpra),
                      ),
                      'year': dateFromYear,
                    };
                    detailModel = _detail;
                  });
                }
              } else {
                print('masuk sini');
                setState(() {
                  initialValues = {
                    'judul': _detail.stepOne!.judul!,
                    'wSungai': SelectedListItem(
                      data: Base(id: _detail.stepOne!.wsungai, nama: _detail.stepOne!.vWsungai),
                    ),
                    'sungai': SelectedListItem(
                      data: Base(id: _detail.stepOne!.sungai, nama: _detail.stepOne!.vSungai),
                    ),
                    'aknop': SelectedListItem(
                      data: Base(id: _detail.stepOne!.jenisAknop, nama: _detail.stepOne!.vJenisAknop),
                    ),
                    'sarpra': SelectedListItem(
                      data: Base(id: _detail.stepOne!.jenisSarpra, nama: _detail.stepOne!.vJenisSarpra),
                    ),
                    'year': dateFromYear,
                  };
                  detailModel = _detail;
                });
              }

              wSungaiController.text = detailModel!.stepOne!.vWsungai!;
              sungaiController.text = detailModel!.stepOne!.vSungai!;
              aknopController.text = detailModel!.stepOne!.vJenisAknop!;
              sarpraController.text = detailModel!.stepOne!.vJenisSarpra!;
              judulController.text = detailModel!.stepOne!.judul!;

              await getListSarpra(_detail.stepOne!.jenisAknop);
              await getListSungai(_detail.stepOne!.wsungai);

              _formKey = GlobalKey<FormBuilderState>();
            },
          );
        }
      };

  Future<void> getListSungai(dynamic id) async {
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

  Future<void> getListSarpra(dynamic id) async {
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
            initialValue: initialValues,
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
                  controller: judulController,
                  validator: FormBuilderValidators.required(errorText: 'Judul Survey tidak boleh kosong'),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                Text('Lokasi Saat Ini'),
                FormBuilderField<List<List<double>>>(
                  name: 'lokasi',
                  // validator: FormBuilderValidators.required(errorText: 'Lokasi tidak boleh kosong'),
                  builder: (field) {
                    return TextField(
                      onTap: () {
                        routeTo(
                          DrawingMapPage.path,
                          data: field.value,
                          result: true,
                          onPop: (value) {
                            if (value != null) {
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
                        hintText: 'Gambar Area Lokasi',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        // error: field.errorText != null
                        //     ? Text(field.errorText ?? '').setStyle(TextStyle(color: Colors.red, fontSize: 12))
                        //     : null,
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
                FormBuilderField<DateTime>(
                  name: 'year',
                  builder: (field) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Pilih Tahun'),
                                content: SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: YearPicker(
                                    firstDate: DateTime(DateTime.now().year - 10, 1),
                                    lastDate: DateTime(2050),
                                    selectedDate: field.value ?? DateTime.now(),
                                    onChanged: (DateTime dateTime) {
                                      field.didChange(dateTime);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${field.value?.year ?? ''}').bodyLarge(),
                      ),
                    );
                  },
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
                      final user = await Auth.data();
                      _formKey.currentState?.saveAndValidate();
                      if (_formKey.currentState?.validate() ?? false) {
                        final currentLocation = await locationProvider.getCurrentLocation();
                        final data = _formKey.currentState!.value;
                        final payload = {
                          'title': widget.data() != 'none' ? 'Ubah' : 'Tambah',
                          'step': 1,
                          'survey': data['judul'],
                          'wsungai': data['wSungai'].data.id,
                          'sungai': data['sungai'].data.id,
                          'aknop': data['aknop'].data.id,
                          'sarpra': data['sarpra'].data.id,
                          'currentLocation': '${currentLocation.latitude},${currentLocation.longitude}',
                          'polygon': jsonEncode({'coordinates': data['lokasi']}),
                          'year': data['year'].toString().substring(0, 4),
                          'pelaksana': user['id'],
                        };

                        if (widget.data() != 'none') {
                          payload['id_survey'] = widget.data();
                        }

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
                          onSuccess: (response, _data) {
                            pop();
                            routeTo(
                              IdentifikasiPage.path,
                              data: _data['data']['id'],
                              navigationType: NavigationType.pushReplace,
                            );
                          },
                          onError: (dioException) {
                            pop();
                            showToastDanger(description: 'Gagal menyimpan data');
                          },
                        );
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
