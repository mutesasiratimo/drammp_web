// To parse this JSON data, do
//
//     final sectorStatsModel = sectorStatsModelFromJson(jsonString);

import 'dart:convert';

List<SectorStatsModel> sectorStatsModelFromJson(String str) =>
    List<SectorStatsModel>.from(
        json.decode(str).map((x) => SectorStatsModel.fromJson(x)));

String sectorStatsModelToJson(List<SectorStatsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SectorStatsModel {
  String sectorid;
  String sectorname;
  List<Sectorcategory> sectorcategories;

  SectorStatsModel({
    required this.sectorid,
    required this.sectorname,
    required this.sectorcategories,
  });

  factory SectorStatsModel.fromJson(Map<String, dynamic> json) =>
      SectorStatsModel(
        sectorid: json["sectorid"],
        sectorname: json["sectorname"],
        sectorcategories: List<Sectorcategory>.from(
            json["sectorcategories"].map((x) => Sectorcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sectorid": sectorid,
        "sectorname": sectorname,
        "sectorcategories":
            List<dynamic>.from(sectorcategories.map((x) => x.toJson())),
      };
}

class Sectorcategory {
  String categoryname;
  int streamcount;
  int expectedrevenue;
  int paidrevenue;

  Sectorcategory({
    required this.categoryname,
    required this.streamcount,
    required this.expectedrevenue,
    required this.paidrevenue,
  });

  factory Sectorcategory.fromJson(Map<String, dynamic> json) => Sectorcategory(
        categoryname: json["categoryname"],
        streamcount: json["streamcount"],
        expectedrevenue: json["expectedrevenue"],
        paidrevenue: json["paidrevenue"],
      );

  Map<String, dynamic> toJson() => {
        "categoryname": categoryname,
        "streamcount": streamcount,
        "expectedrevenue": expectedrevenue,
        "paidrevenue": paidrevenue,
      };
}
