// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<DashSectorStats> welcomeFromJson(String str) => List<DashSectorStats>.from(
    json.decode(str).map((x) => DashSectorStats.fromJson(x)));

String welcomeToJson(List<DashSectorStats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashSectorStats {
  String sectorid;
  String sectorname;
  List<Sectorcategory> sectorcategories;

  DashSectorStats({
    required this.sectorid,
    required this.sectorname,
    required this.sectorcategories,
  });

  factory DashSectorStats.fromJson(Map<String, dynamic> json) =>
      DashSectorStats(
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
  double expectedrevenue;
  double paidrevenue;

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
