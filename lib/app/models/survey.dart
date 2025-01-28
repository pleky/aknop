import 'package:nylo_framework/nylo_framework.dart';

class Survey extends Model {
  static StorageKey key = "survey";
  Survey() : super(key: key);

  String? id;
  String? judul;
  String? latitude;
  String? longitude;
  String? sungai;
  String? wsungai;
  String? aknop;
  String? sarpra;
  String? pelaksana;
  String? created_at;
  String? status;

  Survey.fromJson(data) {
    id = data['id'];
    judul = data['judul'];
    latitude = data['latitude'];
    longitude = data['longitude'];
    sungai = data['sungai'];
    wsungai = data['wsungai'];
    aknop = data['aknop'];
    sarpra = data['sarpra'];
    pelaksana = data['pelaksana'];
    created_at = data['created_at'];
    status = data['status'];
  }

  @override
  toJson() {
    return {
      "id": id,
      "judul": judul,
      "latitude": latitude,
      "longitude": longitude,
      "sungai": sungai,
      "wsungai": wsungai,
      "aknop": aknop,
      "sarpra": sarpra,
      "pelaksana": pelaksana,
      "create_date": created_at,
      "status": status,
    };
  }
}
