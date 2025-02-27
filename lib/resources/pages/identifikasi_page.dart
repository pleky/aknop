import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/models/detail.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/app/networking/transaction_api_service.dart';
import 'package:flutter_app/resources/pages/penentuan_nilai_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class IdentifikasiPage extends NyStatefulWidget {
  static RouteView path = ("/identifikasi", (_) => IdentifikasiPage());

  IdentifikasiPage({super.key}) : super(child: () => _IdentifikasiPageState());
}

class _IdentifikasiPageState extends NyPage<IdentifikasiPage> {
  List<SelectedListItem<Base>> bagianBangunan = [];
  List<SelectedListItem<Base>> kondisi = [];
  late int surveyId;
  var _formKey = GlobalKey<FormBuilderState>();

  var formStates = {
    0: {
      'controllerBagian': TextEditingController(),
      'controllerFungsi': TextEditingController(),
      'controllerFisik': TextEditingController(),
    }
  };

  var totalForm = 1;
  var images = {};

  Map<String, dynamic> initialValues = {};

  @override
  LoadingStyle get loadingStyle => LoadingStyle.skeletonizer();

  @override
  get init => () async {
        surveyId = widget.data();
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
          (request) => request.getAllKondisi(),
          onSuccess: (response, data) {
            List<Base> _res = data;
            List<SelectedListItem<Base>> selectedItems = List<SelectedListItem<Base>>.from(
              _res.map((e) => SelectedListItem(data: e)),
            );
            setState(() {
              kondisi = selectedItems;
            });
          },
        );

        await api<TransactionApiService>(
          (request) => request.detailSurvey(surveyId),
          onSuccess: (response, data) {
            final DetailModel _res = DetailModel.fromJson(data['data']);
            var _data = _res.stepTwo;

            if (_data != null && _data.isNotEmpty) {
              var _form = _data[0];
              formStates[0] = {
                'controllerBagian': TextEditingController(text: _form.bagianBangunan),
                'controllerFungsi': TextEditingController(text: _form.vKondisiFungsi),
                'controllerFisik': TextEditingController(text: _form.vKondisiFisik),
              };

              for (var i = 1; i < _data.length; i++) {
                var _form = _data[i];
                formStates[i] = {
                  'controllerBagian': TextEditingController(text: _form.bagianBangunan),
                  'controllerFungsi': TextEditingController(text: _form.vKondisiFungsi),
                  'controllerFisik': TextEditingController(text: _form.vKondisiFisik),
                };
              }

              setState(() {
                totalForm = _data.length;
              });

              for (var i = 0; i < _data.length; i++) {
                initialValues['judul-$i'] = _data[i].masalah;
                initialValues['tindakan-$i'] = _data[i].tindakan;
                initialValues['fungsi-$i'] =
                    SelectedListItem(data: Base(id: _data[i].kondisiFungsi, nama: _data[i].vKondisiFungsi));
                initialValues['fisik-$i'] =
                    SelectedListItem(data: Base(id: _data[i].kondisiFisik, nama: _data[i].vKondisiFisik));
                initialValues['bagian-$i'] =
                    SelectedListItem(data: Base(id: _data[i].idBagianBangunan, nama: _data[i].bagianBangunan));

                setState(() {
                  images['$i'] = _data[i].buktiSurvey;
                });
              }

              _formKey = GlobalKey<FormBuilderState>();
            }
          },
        );
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          backgroundColor: Color(0xFFe0e0e0),
          value: 0.7,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Center(child: Text('Identifikasi Kegiatan').headingMedium()),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () async {
                        final url = Uri.parse("https://aknop.3ka.my.id/sample.pdf");
                        final canLaunch = await canLaunchUrl(url);
                        if (canLaunch) {
                          await launchUrl(url);
                        }
                      },
                      child: Text('Panduan Pengisian Kreteria')
                          .bodyMedium(color: Colors.blueAccent.shade700, decoration: TextDecoration.underline),
                    ),
                    for (var i = 0; i < totalForm; i++)
                      Fields(
                        index: i,
                        bagianBangunan: bagianBangunan,
                        initialImages: images['$i'] ?? [],
                        formStates: formStates,
                        kondisi: kondisi,
                        onUpload: (imgList) {
                          setState(() {
                            images['$i'] = imgList;
                          });
                        },
                        onDelete: (fieldIndex) {
                          setState(() {
                            totalForm--;
                          });
                        },
                      ),
                    ButtonAddBagian(
                      onTap: () {
                        setState(() {
                          formStates[totalForm] = {
                            'controllerBagian': TextEditingController(),
                            'controllerFungsi': TextEditingController(),
                            'controllerFisik': TextEditingController(),
                          };
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
                          var payload = {
                            "title": "Tambah",
                            "step": 2,
                            "id_survey": surveyId,
                          };

                          var masalah = [];
                          var tindakan = [];
                          var fisik = [];
                          var fungsi = [];
                          var bangunan = [];
                          List<dynamic> bukti = [];

                          for (var i = 0; i < totalForm; i++) {
                            masalah.add(data['judul-$i']);
                            tindakan.add(data['tindakan-$i']);
                            fungsi.add(data['fungsi-$i'].data.id);
                            fisik.add(data['fisik-$i'].data.id);
                            bangunan.add(data['bagian-$i'].data.id);
                            bukti.add(images['$i']);
                          }

                          payload['masalah'] = masalah;
                          payload['tindakan'] = tindakan;
                          payload['kondisiFungsi'] = fungsi;
                          payload['kondisiFisik'] = fisik;
                          payload['bagianbagunan'] = bangunan;
                          payload['bukti_survey'] = bukti;

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
                            (request) => request.saveStep2(payload),
                            onSuccess: (response, _data) {
                              pop();
                              routeTo(
                                PenentuanNilaiPage.path,
                                data: surveyId,
                                navigationType: NavigationType.pushReplace,
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
    required this.formStates,
    required this.bagianBangunan,
    required this.kondisi,
    required this.onDelete,
    required this.onUpload,
    required this.initialImages,
  });

  final int index;
  final Map<int, dynamic> formStates;
  final List<SelectedListItem<Base>> bagianBangunan;
  final List<SelectedListItem<Base>> kondisi;
  final List initialImages;
  final Function(List<String?>) onUpload;
  final Function(int) onDelete;

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  var images = [];

  @override
  void initState() {
    images = widget.initialImages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Visibility(
          visible: widget.index != 0,
          child: Divider(color: Colors.black),
        ),
        Row(children: [
          Text('IDENTIFIKASI ${widget.index + 1}').fontWeightBold(),
          Spacer(),
          Visibility(
            visible: widget.index != 0,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => widget.onDelete.call(widget.index),
            ),
          ),
        ]),
        Text('Bangunan Yang Diamati').bodySmall(),
        MyDropdownField(
          name: 'bagian-${widget.index}',
          controller: widget.formStates[widget.index]['controllerBagian'],
          dataDropdown: widget.bagianBangunan,
          enable: true,
          onSelected: (p0) => {},
          placeholder: 'Pilih Bagian Bangunan',
        ),
        SizedBox(height: 2),
        Text('Upload Bukti Masalah').bodySmall(),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(images.isNotEmpty ? Colors.blueAccent.shade700 : Colors.white),
              foregroundColor: MaterialStateProperty.all(images.isNotEmpty ? Colors.white : Colors.black),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: images.isNotEmpty ? Colors.blueAccent.shade700 : Colors.grey))),
            ),
            child: Text('UPLOAD FOTO'),
            onPressed: () {
              WoltModalSheet.show<void>(
                context: context,
                modalTypeBuilder: (context) => WoltModalType.dialog(),
                useSafeArea: false,
                pageListBuilder: (context) => [
                  WoltModalSheetPage(
                    hasTopBarLayer: false,
                    forceMaxHeight: true,
                    child: UploadModal(
                      images: images,
                      onClose: (p0) {},
                      onUpload: (imgs) {
                        imgs.forEach((element) {
                          setState(() {
                            images.add(element);
                          });
                        });

                        widget.onUpload(imgs);
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
        SizedBox(height: 2),
        Text('Judul Masalah').bodySmall(),
        FormBuilderTextField(
          name: 'judul-${widget.index}',
          maxLines: 3,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text('Tindakan yang Diperlukan').bodySmall(),
        FormBuilderTextField(
          name: 'tindakan-${widget.index}',
          maxLines: 3,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text('Kondisi Fungsi').bodySmall(),
        MyDropdownField(
          name: 'fungsi-${widget.index}',
          controller: widget.formStates[widget.index]['controllerFungsi'],
          dataDropdown: widget.kondisi,
          enable: true,
          onSelected: (p0) => print(p0),
          placeholder: 'Pilih Kondisi Fungsi',
        ),
        SizedBox(height: 2),
        Text('Kondisi Fisik').bodySmall(),
        MyDropdownField(
          name: 'fisik-${widget.index}',
          controller: widget.formStates[widget.index]['controllerFisik'],
          dataDropdown: widget.kondisi,
          enable: true,
          onSelected: (p0) => print(p0),
          placeholder: 'Pilih Kondisi Fisik',
        ),
        SizedBox(height: 8),
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

class UploadModal extends StatefulWidget {
  final List images;
  final Function(List<String?>) onUpload;
  final Function(List) onClose;

  const UploadModal({
    required this.images,
    required this.onUpload,
    required this.onClose,
    super.key,
  });

  @override
  _UploadModalState createState() => _UploadModalState();
}

class _UploadModalState extends State<UploadModal> {
  bool isLoading = false;

  final TransactionApiService _apiService = TransactionApiService();
  List _tempImages = [];

  @override
  void initState() {
    widget.images.forEach((element) {
      if (element.contains('http')) {
        _tempImages.add(element);
      }
    });
    super.initState();
  }

  Future<void> upload() async {
    setState(() {
      isLoading = true;
    });

    if (_tempImages.isNotEmpty) {
      final data = await Future.wait(_tempImages.map((e) async {
        if (!e.contains('http')) {
          final _res = await _apiService.upload(File(e));
          return _res;
        }
      }));
      final remoteimgs = _tempImages.where((element) => element.contains('http')).toList();
      final filteredData = data.where((element) => element != null).toList();
      remoteimgs.forEach((element) {
        filteredData.add(element);
      });

      Navigator.of(context).pop();
      widget.onUpload.call(filteredData);
    }
  }

  String _getFileName(String? path) {
    if (path == null) return '';

    return path.split('/').last;
  }

  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Format gambar yang dapat di kirim hanya\n',
              children: [
                TextSpan(text: 'berupa'),
                TextSpan(text: ' .jpg, .jpeg, .png', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' dan ukuran file\n'),
                TextSpan(text: 'maksimal 10Mb', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: _tempImages.length >= 5
              ? null
              : () {
                  WoltModalSheet.show(
                    context: context,
                    modalTypeBuilder: (context) => WoltModalType.dialog(),
                    useSafeArea: false,
                    pageListBuilder: (context) {
                      return [
                        WoltModalSheetPage(
                          hasTopBarLayer: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text('Kamera'),
                                onTap: () async {
                                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                  if (photo != null) {
                                    setState(() {
                                      _tempImages.add(photo.path);
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              ListTile(
                                title: Text('Galeri'),
                                onTap: () async {
                                  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                                  if (photo != null) {
                                    setState(() {
                                      _tempImages.add(photo.path);
                                    });

                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  );
                },
          child: Center(
            child: DottedBorder(
              dashPattern: [3],
              radius: Radius.circular(8),
              color: _tempImages.length >= 5 ? Colors.grey : Colors.blueAccent.shade700,
              borderType: BorderType.RRect,
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    // color: Colors.blueAccent.shade700,
                    color: _tempImages.length >= 5 ? Colors.grey : Colors.blueAccent.shade700,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        SizedBox(
          height: 250,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              children: [
                Expanded(
                  child: Text(_getFileName(_tempImages[index])).bodySmall(),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _tempImages.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            itemCount: _tempImages.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black, height: 1),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: OutlinedButton(
            child: isLoading ? CircularProgressIndicator() : Text('Simpan'),
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
            onPressed: isLoading || _tempImages.isEmpty ? null : upload,
          ),
        ),
      ],
    );
  }
}
