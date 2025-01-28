import 'package:dotted_border/dotted_border.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/identifikasi_form.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:flutter_app/resources/pages/penentuan_nilai_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:flutter_app/resources/widgets/my_dropdown.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class IdentifikasiPage extends NyStatefulWidget {
  static RouteView path = ("/identifikasi", (_) => IdentifikasiPage());

  IdentifikasiPage({super.key}) : super(child: () => _IdentifikasiPageState());
}

class _IdentifikasiPageState extends NyPage<IdentifikasiPage> {
  List<SelectedListItem<Base>> bagianBangunan = [];
  List<SelectedListItem<Base>> kondisi = [];

  var formStates = [
    {
      'controllerBagian': TextEditingController(),
      'controllerFungsi': TextEditingController(),
      'controllerFisik': TextEditingController(),
    }
  ];

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
      };

  final _formKey = GlobalKey<FormBuilderState>();

  int totalForm = 1;

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
                    for (var i = 0; i < totalForm; i++)
                      Fields(
                        index: i,
                        bagianBangunan: bagianBangunan,
                        formStates: formStates,
                        kondisi: kondisi,
                        onDelete: () {
                          setState(() {
                            totalForm--;
                            formStates.removeAt(i);
                          });
                        },
                      ),
                    ButtonAddBagian(
                      onTap: () {
                        setState(() {
                          totalForm++;
                          formStates.add({
                            'controllerBagian': TextEditingController(),
                            'controllerFungsi': TextEditingController(),
                            'controllerFisik': TextEditingController(),
                          });
                        });
                      },
                    ),
                    Spacer(),
                    Button.rounded(
                      text: 'Simpan Data',
                      onPressed: () {
                        routeTo(PenentuanNilaiPage.path);
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
  });

  final int index;
  final List<Map<String, dynamic>> formStates;
  final List<SelectedListItem<Base>> bagianBangunan;
  final List<SelectedListItem<Base>> kondisi;
  final VoidCallback onDelete;

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  var images = [];

  String _getFileName(String path) {
    return path.split('/').last;
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
              onPressed: widget.onDelete,
            ),
          ),
        ]),
        Text('Bangunan Yang Diamati').bodySmall(),
        MyDropdownField(
          name: 'bagian-${widget.index}',
          controller: widget.formStates[widget.index]['controllerBagian'],
          dataDropdown: widget.bagianBangunan,
          enable: true,
          onSelected: (p0) => print(p0),
          placeholder: 'Pilih Bagian Bangunan',
        ),
        SizedBox(height: 2),
        Text('Upload Bukti Masalah').bodySmall(),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(images.isEmpty ? Colors.white : Colors.blueAccent.shade700),
              foregroundColor: MaterialStateProperty.all(images.isEmpty ? Colors.black : Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: images.isEmpty ? Colors.grey : Colors.blueAccent.shade700))),
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
                    child: StatefulBuilder(
                      builder: (context, _setState) {
                        final ImagePicker _picker = ImagePicker();
                        var _tempImages = images;
                        debugPrint('images: $images');
                        debugPrint('_tempImages: $_tempImages');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  images = _tempImages;
                                });
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
                              onTap: () {
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
                                                final XFile? photo =
                                                    await _picker.pickImage(source: ImageSource.camera);
                                                if (photo != null) {
                                                  _setState(() {
                                                    _tempImages.add(photo.path);
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            ListTile(
                                              title: Text('Galeri'),
                                              onTap: () async {
                                                final XFile? photo =
                                                    await _picker.pickImage(source: ImageSource.gallery);
                                                if (photo != null) {
                                                  _setState(() {
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
                                  color: Colors.blueAccent.shade700,
                                  borderType: BorderType.RRect,
                                  child: Container(
                                    height: 100,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(alpha: 100),
                                          spreadRadius: 0.5,
                                          blurRadius: 5,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.blueAccent.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              height: 300,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    Expanded(
                                      child: Text(_getFileName(images[index])).bodySmall(),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        _setState(() {
                                          _tempImages.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                itemCount: images.length,
                                separatorBuilder: (context, index) => Divider(color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              child: OutlinedButton(
                                child: Text('Simpan').titleMedium(color: Colors.black, fontWeight: FontWeight.w600),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                                    return Color(0xFF61eabc);
                                  }),
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) {
                                      return BorderSide(color: Colors.black);
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    images = _tempImages;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        );
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
