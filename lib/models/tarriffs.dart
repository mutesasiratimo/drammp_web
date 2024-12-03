// To parse this JSON data, do
//
//     final tarriffsModel = tarriffsModelFromJson(jsonString);

import 'dart:convert';

List<TarriffsModel> tarriffsModelFromJson(String str) =>
    List<TarriffsModel>.from(
        json.decode(str).map((x) => TarriffsModel.fromJson(x)));

String tarriffsModelToJson(List<TarriffsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TarriffsModel {
  String id;
  String sectorsubtypeid;
  String sectorsubtypename;
  String purpose;
  int amount;
  String frequency;
  int frequencydays;
  DateTime datecreated;
  String createdby;
  DateTime dateupdated;
  String updatedby;
  String status;

  TarriffsModel({
    required this.id,
    required this.sectorsubtypeid,
    required this.sectorsubtypename,
    required this.purpose,
    required this.amount,
    required this.frequency,
    required this.frequencydays,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory TarriffsModel.fromJson(Map<String, dynamic> json) => TarriffsModel(
        id: json["id"],
        sectorsubtypeid: json["sectorsubtypeid"],
        sectorsubtypename: json["sectorsubtypename"],
        purpose: json["purpose"],
        amount: json["amount"],
        frequency: json["frequency"],
        frequencydays: json["frequencydays"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sectorsubtypeid": sectorsubtypeid,
        "sectorsubtypename": sectorsubtypename,
        "purpose": purpose,
        "amount": amount,
        "frequency": frequency,
        "frequencydays": frequencydays,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
