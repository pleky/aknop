import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/models/hsp.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/app/utils/formatter.dart';
import 'package:flutter_app/resources/pages/summary_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/penentuan_nilai_controller.dart';

class PenentuanNilaiPage extends NyStatefulWidget<PenentuanNilaiController> {
  static RouteView path = ("/penentuan-nilai", (_) => PenentuanNilaiPage());

  PenentuanNilaiPage({super.key}) : super(child: () => _PenentuanNilaiPageState());
}

class _PenentuanNilaiPageState extends NyState<PenentuanNilaiPage> {
  /// [PenentuanNilaiController] controller
  PenentuanNilaiController get controller => widget.controller;

  List<SelectedListItem<Base>> bagianBangunan = [];
  List<SelectedListItem<Base>> subPekerjaan = [];
  var _formKey = GlobalKey<FormBuilderState>();
  int totalForm = 1;
  Map<String, dynamic> initialValues = {};

  @override
  LoadingStyle get loadingStyle => LoadingStyle.skeletonizer();

  @override
  get init => () async {
        await api<MasterApiService>(
          (request) => request.getAllBagianBangunan(),
          onSuccess: (response, data) {
            List<Base> _res = data;
            List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
              _res.map((e) => SelectedListItem(data: e)),
            );
            setState(() {
              bagianBangunan = selectedItems;
            });
          },
        );

        await api<MasterApiService>(
          (request) => request.getAllSubPekerjaan(),
          onSuccess: (response, data) {
            List<Base> _res = data;
            List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
              _res.map((e) => SelectedListItem(data: e)),
            );
            setState(() {
              subPekerjaan = selectedItems;
            });
          },
        );

        final surveyId = widget.data();

        await api<TransactionApiService>(
          (request) => request.detailSurvey(surveyId),
          onSuccess: (response, data) {
            final DetailModel _res = DetailModel.fromJson(data['data']);
            var _data = _res.stepThree;
            if (_data == null || _data.isEmpty) return;

            totalForm = _data.length;

            for (var i = 0; i < _data.length; i++) {
              initialValues['bagian-$i'] =
                  SelectedListItem(data: Base(id: _data[i].tigaBagianBangunan, nama: _data[i].vTigaBagianBangunan));
              initialValues['sub-pekerjaan-$i'] =
                  SelectedListItem(data: Base(id: _data[i].tigaHsp, nama: _data[i].vTigaHsp));
              controller.setSubHspIds(_data[i].tigaSubHsp, i);
              controller.setTotalFields(_data[i].tigaVolume!.length, i);

              for (var j = 0; j < _data[i].tigaVolume!.length; j++) {
                initialValues['pekerjaan-$i-$j'] = CurrencyFormat.convertToIdr(int.parse(_data[i].tigaVolume![j]), 0);
                initialValues['satuan-$i-$j'] = CurrencyFormat.convertToIdr(int.parse(_data[i].tigaHasil![j]), 0);
              }
            }

            _formKey = GlobalKey<FormBuilderState>();
          },
        );
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          backgroundColor: Color(0xFFe0e0e0),
          value: 0.9,
        ),
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
        child: FormBuilder(
          key: _formKey,
          initialValue: initialValues,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 90,
              ),
              child: IntrinsicHeight(
                child: Column(
                  spacing: 8,
                  children: [
                    Center(child: Text('Penentuan Nilai').headingMedium()),
                    for (int i = 0; i < totalForm; i++)
                      Fields(
                        bagianBangunan: bagianBangunan,
                        subPekerjaan: subPekerjaan,
                        index: i,
                        initialData: initialValues,
                        controller: controller,
                        formKey: _formKey,
                        onDelete: () {
                          setState(() {
                            totalForm--;
                          });
                        },
                      ),
                    ButtonAddBagian(
                      onTap: () {
                        setState(() {
                          totalForm++;
                        });
                      },
                    ),
                    Spacer(),
                    Button.rounded(
                      text: 'Simpan Data',
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();

                        if (_formKey.currentState?.validate() ?? false) {
                          final data = _formKey.currentState!.value;

                          var _payload = [];
                          Map<String, dynamic> volume = {};
                          Map<String, dynamic> hasil = {};

                          for (var i = 0; i < totalForm; i++) {
                            volume['$i'] = [];
                            hasil['$i'] = [];

                            for (var j = 0; j < controller.totalFields['$i']; j++) {
                              var pekerjaan = data['pekerjaan-$i-$j'];
                              var satuan = data['satuan-$i-$j'];

                              if (pekerjaan != null && pekerjaan != '') {
                                (volume['$i'] as List).add(CurrencyFormat.removeGroupSeparator(pekerjaan));
                              }
                              if (satuan != null && satuan != '') {
                                (hasil['$i'] as List).add(CurrencyFormat.removeGroupSeparator(satuan));
                              }
                            }

                            _payload.add({
                              "title": "Tambah",
                              "step": 3,
                              "tiga_seq": i,
                              "id_survey": widget.data(),
                              "tiga_bagian_bangunan": data['bagian-$i'].data.id,
                              "tiga_hsp": data['sub-pekerjaan-${i}'].data.id,
                              "tiga_sub_hsp": controller.subHspIds['$i'],
                              "tiga_volume": volume['$i'],
                              "tiga_hasil": hasil['$i'],
                            });
                          }

                          print(_payload);

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
                            (request) => request.saveStep3(_payload),
                            onSuccess: (response, _data) {
                              pop();
                              routeTo(
                                SummaryPage.path,
                                navigationType: NavigationType.pushReplace,
                                data: widget.data(),
                              );
                            },
                            onError: (dioException) {
                              pop();
                              showToastDanger(description: 'Gagal menyimpan data');
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Fields extends StatefulWidget {
  Fields({
    super.key,
    required this.index,
    required this.bagianBangunan,
    required this.onDelete,
    required this.subPekerjaan,
    required this.controller,
    required this.formKey,
    required this.initialData,
  });

  final int index;
  final List<SelectedListItem<Base>> bagianBangunan;
  final List<SelectedListItem<Base>> subPekerjaan;
  final VoidCallback onDelete;
  final PenentuanNilaiController controller;
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> initialData;

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  final TextEditingController bagianController = TextEditingController();
  final TextEditingController subPekerjaanController = TextEditingController();
  MasterApiService _apiService = MasterApiService();

  Map<String, dynamic> _fields = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialData.isNotEmpty) {
      if (widget.initialData['bagian-${widget.index}'] != null) {
        bagianController.text = widget.initialData['bagian-${widget.index}'].data.nama;
      }

      if (widget.initialData['sub-pekerjaan-${widget.index}'] != null) {
        subPekerjaanController.text = widget.initialData['sub-pekerjaan-${widget.index}'].data.nama;
        _onChangeHSP(
          widget.initialData['sub-pekerjaan-${widget.index}'].data.id!,
          widget.index,
          initialData: widget.initialData,
        );
      }
    }
  }

  void _onChangeHSP(dynamic id, dynamic index, {Map<String, dynamic>? initialData}) async {
    try {
      List<Hsp>? _res = await _apiService.getAllHSP(id);
      if (_res?.isNotEmpty == true) {
        widget.controller.setTotalFields(_res!.length, widget.index);
        List<dynamic> _hspIds = [];

        _res.forEach((element) {
          _hspIds.add(element.id!);
        });

        widget.controller.setSubHspIds(_hspIds, widget.index);

        setState(() {
          _fields[index.toString()] = _res.map((element) {
            return {
              'id': element.id,
              'controller': TextEditingController(),
              'harga': element.hargaSatuan,
              'harga-controller': TextEditingController(),
              'pekerjaan': element.uraianPekerjaan,
              'satuan': element.satuan,
              'satuan-controller': TextEditingController(),
            };
          }).toList();
        });

        if (initialData != null) {
          for (int i = 0; i < _res.length; i++) {
            final field = _fields[index.toString()][i];

            field['controller'].text = initialData['pekerjaan-$index-$i'];
            field['satuan-controller'].text = initialData['satuan-$index-$i'];
            widget.formKey.currentState?.fields['pekerjaan-$index-$i']?.didChange(initialData['pekerjaan-$index-$i']);
            widget.formKey.currentState?.fields['satuan-$index-$i']?.didChange(initialData['satuan-$index-$i']);
          }
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Visibility(
          visible: widget.index != 0,
          child: Divider(
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Text('Survey ${widget.index + 1}').fontWeightBold(),
            Spacer(),
            Visibility(
              visible: widget.index != 0,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            )
          ],
        ),
        Text('Bangunan Yang Diamati').bodySmall(),
        MyDropdownField(
          name: 'bagian-${widget.index}',
          controller: bagianController,
          dataDropdown: widget.bagianBangunan,
          enable: true,
          errorText: "Bangunan yang diamati tidak boleh kosong",
          onSelected: (p0) {},
          placeholder: 'Pilih Bagian Bangunan',
        ),
        SizedBox(height: 2),
        Text('HSP').bodySmall(),
        MyDropdownField(
          name: 'sub-pekerjaan-${widget.index}',
          dataDropdown: widget.subPekerjaan,
          enable: true,
          controller: subPekerjaanController,
          errorText: 'HSP tidak boleh kosong',
          onSelected: (item) {
            _onChangeHSP(item.data.id!, widget.index);
          },
          placeholder: 'Pilih Sub Pekerjaan',
        ),
        SizedBox(height: 2),
        if (_fields[widget.index.toString()] != null)
          for (int i = 0; i < _fields[widget.index.toString()]?.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_fields[widget.index.toString()][i]['pekerjaan']).bodySmall(),
                SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'pekerjaan-${widget.index}-$i',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(errorText: 'Harus diisi'),
                  inputFormatters: [
                    NumberTextInputFormatter(
                      integerDigits: 10,
                      decimalDigits: 0,
                      decimalSeparator: ',',
                      groupDigits: 3,
                      groupSeparator: '.',
                      allowNegative: false,
                      overrideDecimalPoint: true,
                      insertDecimalPoint: false,
                      insertDecimalDigits: false,
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null && val.isNotEmpty) {
                      final field = _fields[widget.index.toString()][i];
                      TextEditingController _satuanController = field['satuan-controller'];
                      final originalValue = CurrencyFormat.removeGroupSeparator(val);
                      final total = int.parse(field['harga']) * int.parse(originalValue);
                      final currency = CurrencyFormat.convertToIdr(total, 0);
                      _satuanController.text = currency;
                      widget.formKey.currentState?.fields['satuan-${widget.index}-$i']?.didChange(currency);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Masukkan Angka1',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 8),
                Text(_fields[widget.index.toString()][i]['satuan']).titleSmall(),
                SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'satuan-${widget.index}-$i',
                  controller: _fields[widget.index.toString()][i]['satuan-controller'],
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Masukkan Angka',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
      ],
    );
  }
}

class ButtonAddBagian extends StatelessWidget {
  const ButtonAddBagian({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent.shade700, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 50),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.blueAccent.shade700,
            ),
            Text('Tambah Bagian').titleMedium(color: Colors.blueAccent.shade700),
          ],
        ),
      ),
    );
  }
}
