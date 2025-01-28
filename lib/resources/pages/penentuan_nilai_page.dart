import 'dart:math';

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/models/hsp.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/resources/pages/summary_page.dart';
import 'package:flutter_app/resources/pages/volume_penentuan_nilai_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  int totalForm = 1;

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
                      onPressed: () {
                        routeTo(SummaryPage.path);
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
  });

  final int index;
  final List<SelectedListItem<Base>> bagianBangunan;
  final List<SelectedListItem<Base>> subPekerjaan;
  final VoidCallback onDelete;

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  final TextEditingController bagianController = TextEditingController();
  final TextEditingController subPekerjaanController = TextEditingController();

  Map<String, dynamic> _fields = {};

  void _onChangeHSP(int id, int index) async {
    await api<MasterApiService>(
      (request) => request.getAllHSP(id),
      onSuccess: (response, data) {
        List<Hsp> _res = data;

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('fields: $_fields');
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
                  controller: _fields[widget.index.toString()][i]['controller'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Masukkan Angka',
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
