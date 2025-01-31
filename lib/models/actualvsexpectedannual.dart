// To parse this JSON data, do
//
//     final annualActualVsExpectedModel = annualActualVsExpectedModelFromJson(jsonString);

import 'dart:convert';

List<AnnualActualVsExpectedModel> annualActualVsExpectedModelFromJson(
        String str) =>
    List<AnnualActualVsExpectedModel>.from(
        json.decode(str).map((x) => AnnualActualVsExpectedModel.fromJson(x)));

String annualActualVsExpectedModelToJson(
        List<AnnualActualVsExpectedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnnualActualVsExpectedModel {
  int month;
  double expectedrevenue;
  double paidrevenue;

  AnnualActualVsExpectedModel({
    required this.month,
    required this.expectedrevenue,
    required this.paidrevenue,
  });

  factory AnnualActualVsExpectedModel.fromJson(Map<String, dynamic> json) =>
      AnnualActualVsExpectedModel(
        month: json["month"],
        expectedrevenue: json["expectedrevenue"],
        paidrevenue: json["paidrevenue"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "expectedrevenue": expectedrevenue,
        "paidrevenue": paidrevenue,
      };
}
