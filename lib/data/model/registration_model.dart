import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) =>
    RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) =>
    json.encode(data.toJson());

class RegistrationModel {
  RegistrationModel({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  String? data;

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      RegistrationModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
