import 'package:nylo_framework/nylo_framework.dart';

class Base extends Model {
  int? id;
  String? nama;

  static StorageKey key = "base";

  Base() : super(key: key);

  Base.fromJson(dynamic data) {
    id = data['id'];
    nama = data['nama'];
  }

  @override
  toJson() {
    return {"nama": nama, "id": id};
  }
}
