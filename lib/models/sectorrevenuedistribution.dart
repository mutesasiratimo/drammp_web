// To parse this JSON data, do
//
//     final sectorRevenueDistributionModel = sectorRevenueDistributionModelFromJson(jsonString);

import 'dart:convert';

List<SectorRevenueDistributionModel> sectorRevenueDistributionModelFromJson(
        String str) =>
    List<SectorRevenueDistributionModel>.from(json
        .decode(str)
        .map((x) => SectorRevenueDistributionModel.fromJson(x)));

String sectorRevenueDistributionModelToJson(
        List<SectorRevenueDistributionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SectorRevenueDistributionModel {
  String sectorid;
  String sectorname;
  int streamcount;
  int expectedrevenue;
  int paidrevenue;

  SectorRevenueDistributionModel({
    required this.sectorid,
    required this.sectorname,
    required this.streamcount,
    required this.expectedrevenue,
    required this.paidrevenue,
  });

  factory SectorRevenueDistributionModel.fromJson(Map<String, dynamic> json) =>
      SectorRevenueDistributionModel(
        sectorid: json["sectorid"],
        sectorname: json["sectorname"],
        streamcount: json["streamcount"],
        expectedrevenue: json["expectedrevenue"],
        paidrevenue: json["paidrevenue"],
      );

  Map<String, dynamic> toJson() => {
        "sectorid": sectorid,
        "sectorname": sectorname,
        "streamcount": streamcount,
        "expectedrevenue": expectedrevenue,
        "paidrevenue": paidrevenue,
      };
}
