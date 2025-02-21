import 'package:nylo_framework/nylo_framework.dart';

class HomeModel {
  UserHome? user;
  Dashboard? dashboard;

  static StorageKey key = "HomeModel";

  HomeModel({this.user, this.dashboard});

  HomeModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserHome.fromJson(json['user']) : null;
    dashboard = json['dashboard'] != null ? new Dashboard.fromJson(json['dashboard']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard!.toJson();
    }
    return data;
  }
}

class UserHome {
  int? id;
  String? username;
  String? email;
  String? perusahaan;
  String? role;

  UserHome({this.id, this.username, this.email, this.perusahaan, this.role});

  UserHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    perusahaan = json['perusahaan'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['perusahaan'] = this.perusahaan;
    data['role'] = this.role;
    return data;
  }
}

class Dashboard {
  int? surveyTotal;
  int? surveyDraft;
  int? surveyCompleted;

  Dashboard({this.surveyTotal, this.surveyDraft, this.surveyCompleted});

  Dashboard.fromJson(Map<String, dynamic> json) {
    surveyTotal = json['survey_total'];
    surveyDraft = json['survey_draft'];
    surveyCompleted = json['survey_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['survey_total'] = this.surveyTotal;
    data['survey_draft'] = this.surveyDraft;
    data['survey_completed'] = this.surveyCompleted;
    return data;
  }
}
