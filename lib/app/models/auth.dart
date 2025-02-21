import 'package:nylo_framework/nylo_framework.dart';

class AuthModel {
  static StorageKey key = "auth";

  int? id;
  String? username;
  String? email;
  String? password;
  String? nama;
  String? perusahaan;
  String? alamat;
  String? noTelp;
  String? role;
  String? photo;
  String? status;

  AuthModel(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.nama,
      this.perusahaan,
      this.alamat,
      this.noTelp,
      this.role,
      this.photo,
      this.status});

  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    nama = json['nama'];
    perusahaan = json['perusahaan'];
    alamat = json['alamat'];
    noTelp = json['no_telp'];
    role = json['role'];
    photo = json['photo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['nama'] = this.nama;
    data['perusahaan'] = this.perusahaan;
    data['alamat'] = this.alamat;
    data['no_telp'] = this.noTelp;
    data['role'] = this.role;
    data['photo'] = this.photo;
    data['status'] = this.status;
    return data;
  }
}
