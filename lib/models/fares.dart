// To parse this JSON data, do
//
//     final faresModel = faresModelFromJson(jsonString);

import 'dart:convert';

List<FaresModel> faresModelFromJson(String str) =>
    List<FaresModel>.from(json.decode(str).map((x) => FaresModel.fromJson(x)));

String faresModelToJson(List<FaresModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaresModel {
  String id;
  String sectorsubtypeid;
  String sectorsubtypename;
  double basefare;
  double durationrate;
  double firstkm;
  double nextkm;
  double firstkmrate;
  double nextkmrate;
  double ratekmafter;
  DateTime datecreated;
  String createdby;
  DateTime dateupdated;
  String updatedby;
  String status;

  FaresModel({
    required this.id,
    required this.sectorsubtypeid,
    required this.sectorsubtypename,
    required this.basefare,
    required this.durationrate,
    required this.firstkm,
    required this.nextkm,
    required this.firstkmrate,
    required this.nextkmrate,
    required this.ratekmafter,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory FaresModel.fromJson(Map<String, dynamic> json) => FaresModel(
        id: json["id"],
        sectorsubtypeid: json["sectorsubtypeid"],
        sectorsubtypename: json["sectorsubtypename"],
        basefare: json["basefare"],
        durationrate: json["durationrate"],
        firstkm: json["firstkm"],
        nextkm: json["nextkm"],
        firstkmrate: json["firstkmrate"],
        nextkmrate: json["nextkmrate"],
        ratekmafter: json["ratekmafter"],
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
        "basefare": basefare,
        "durationrate": durationrate,
        "firstkm": firstkm,
        "nextkm": nextkm,
        "firstkmrate": firstkmrate,
        "nextkmrate": nextkmrate,
        "ratekmafter": ratekmafter,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
