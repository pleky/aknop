import 'package:nylo_framework/nylo_framework.dart';

class Hsp extends Model {
  static StorageKey key = "hsp";

  Hsp() : super(key: key);

  int? id;
  String? uraianPekerjaan;
  String? satuan;
  String? hargaSatuan;

  Hsp.fromJson(data) {
    id = data['id'];
    uraianPekerjaan = data['uraian_pekerjaan'];
    satuan = data['satuan'];
    hargaSatuan = data['harga_satuan'];
  }

  @override
  toJson() {
    return {"id": id, "uraian_pekerjaan": uraianPekerjaan, "satuan": satuan, "harga_satuan": hargaSatuan};
  }
}
