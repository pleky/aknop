class DetailModel {
  StepOne? stepOne;
  List<StepTwo>? stepTwo;
  List<StepThree>? stepThree;

  DetailModel({this.stepOne, this.stepTwo, this.stepThree});

  DetailModel.fromJson(Map<String, dynamic> json) {
    stepOne = json['step_one'] != null ? new StepOne.fromJson(json['step_one']) : null;
    if (json['step_two'] != null) {
      stepTwo = <StepTwo>[];
      json['step_two'].forEach((v) {
        stepTwo!.add(new StepTwo.fromJson(v));
      });
    }
    if (json['step_three'] != null) {
      stepThree = <StepThree>[];
      json['step_three'].forEach((v) {
        stepThree!.add(new StepThree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stepOne != null) {
      data['step_one'] = this.stepOne!.toJson();
    }
    if (this.stepTwo != null) {
      data['step_two'] = this.stepTwo!.map((v) => v.toJson()).toList();
    }
    if (this.stepThree != null) {
      data['step_three'] = this.stepThree!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StepOne {
  dynamic id;
  String? judul;
  String? wsungai;
  String? sungai;
  String? jenisAknop;
  String? jenisSarpra;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  String? status;
  String? year;
  String? polygon;
  String? vWsungai;
  String? vSungai;
  String? vJenisAknop;
  String? vJenisSarpra;
  String? vPelaksana;

  StepOne({
    this.id,
    this.judul,
    this.wsungai,
    this.sungai,
    this.jenisAknop,
    this.jenisSarpra,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.status,
    this.year,
    this.polygon,
    this.vWsungai,
    this.vSungai,
    this.vJenisAknop,
    this.vJenisSarpra,
    this.vPelaksana,
  });

  StepOne.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    wsungai = json['wsungai'];
    sungai = json['sungai'];
    jenisAknop = json['jenis_aknop'];
    jenisSarpra = json['jenis_sarpra'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    year = json['year'];
    polygon = json['polygon'];
    vWsungai = json['v_wsungai'];
    vSungai = json['v_sungai'];
    vJenisAknop = json['v_jenis_aknop'];
    vJenisSarpra = json['v_jenis_sarpra'];
    vPelaksana = json['v_pelaksana'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['wsungai'] = this.wsungai;
    data['sungai'] = this.sungai;
    data['jenis_aknop'] = this.jenisAknop;
    data['jenis_sarpra'] = this.jenisSarpra;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['year'] = this.year;
    data['polygon'] = this.polygon;
    data['v_wsungai'] = this.vWsungai;
    data['v_sungai'] = this.vSungai;
    data['v_jenis_aknop'] = this.vJenisAknop;
    data['v_jenis_sarpra'] = this.vJenisSarpra;
    data['v_pelaksana'] = this.vPelaksana;
    return data;
  }
}

class StepTwo {
  String? id;
  String? idSurvey;
  String? masalah;
  String? tindakan;
  String? kondisiFungsi;
  String? kondisiFisik;
  String? bagianBangunan;
  String? idBagianBangunan;
  String? vKondisiFungsi;
  String? vKondisiFisik;
  String? buktiSurvey;

  StepTwo({
    this.id,
    this.idSurvey,
    this.masalah,
    this.tindakan,
    this.kondisiFungsi,
    this.kondisiFisik,
    this.bagianBangunan,
    this.idBagianBangunan,
    this.vKondisiFungsi,
    this.vKondisiFisik,
    this.buktiSurvey,
  });

  StepTwo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idSurvey = json['id_survey'];
    masalah = json['masalah'];
    tindakan = json['tindakan'];
    kondisiFungsi = json['kondisi_fungsi'];
    kondisiFisik = json['kondisi_fisik'];
    bagianBangunan = json['bagian_bangunan'];
    idBagianBangunan = json['id_bagian_bangunan'];
    vKondisiFungsi = json['v_kondisi_fungsi'];
    vKondisiFisik = json['v_kondisi_fisik'];
    buktiSurvey = json['bukti_survey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_survey'] = this.idSurvey;
    data['masalah'] = this.masalah;
    data['tindakan'] = this.tindakan;
    data['kondisi_fungsi'] = this.kondisiFungsi;
    data['kondisi_fisik'] = this.kondisiFisik;
    data['bagian_bangunan'] = this.bagianBangunan;
    data['id_bagian_bangunan'] = this.idBagianBangunan;
    data['v_kondisi_fungsi'] = this.vKondisiFungsi;
    data['v_kondisi_fisik'] = this.vKondisiFisik;
    data['bukti_survey'] = this.buktiSurvey;
    return data;
  }
}

class StepThree {
  String? id;
  int? step;
  String? idSurvey;
  String? tigaBagianBangunan;
  String? vTigaBagianBangunan;
  String? tigaHsp;
  String? vTigaHsp;
  List<String>? tigaSubHsp;
  List<String>? vTigaSubHsp;
  List<String>? tigaVolume;
  List<String>? tigaHasil;
  List<String>? tigaSatuan;

  StepThree(
      {this.id,
      this.step,
      this.idSurvey,
      this.tigaBagianBangunan,
      this.vTigaBagianBangunan,
      this.tigaHsp,
      this.vTigaHsp,
      this.tigaSubHsp,
      this.vTigaSubHsp,
      this.tigaVolume,
      this.tigaHasil,
      this.tigaSatuan});

  StepThree.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    step = json['step'];
    idSurvey = json['id_survey'];
    tigaBagianBangunan = json['tiga_bagian_bangunan'];
    vTigaBagianBangunan = json['v_tiga_bagian_bangunan'];
    tigaHsp = json['tiga_hsp'];
    vTigaHsp = json['v_tiga_hsp'];
    tigaSubHsp = json['tiga_sub_hsp'].cast<String>();
    vTigaSubHsp = json['v_tiga_sub_hsp'].cast<String>();
    tigaVolume = json['tiga_volume'].cast<String>();
    tigaHasil = json['tiga_hasil'].cast<String>();
    tigaSatuan = json['tiga_satuan'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['step'] = this.step;
    data['id_survey'] = this.idSurvey;
    data['tiga_bagian_bangunan'] = this.tigaBagianBangunan;
    data['v_tiga_bagian_bangunan'] = this.vTigaBagianBangunan;
    data['tiga_hsp'] = this.tigaHsp;
    data['v_tiga_hsp'] = this.vTigaHsp;
    data['tiga_sub_hsp'] = this.tigaSubHsp;
    data['v_tiga_sub_hsp'] = this.vTigaSubHsp;
    data['tiga_volume'] = this.tigaVolume;
    data['tiga_hasil'] = this.tigaHasil;
    data['tiga_satuan'] = this.tigaSatuan;
    return data;
  }
}
