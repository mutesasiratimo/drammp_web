// To parse this JSON data, do
//
//     final revenueSectorCategoriesModel = revenueSectorCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<RevenueSectorCategoriesFilteredModel> revenueSectorCategoriesModelFromJson(
        String str) =>
    List<RevenueSectorCategoriesFilteredModel>.from(json
        .decode(str)
        .map((x) => RevenueSectorCategoriesFilteredModel.fromJson(x)));

String revenueSectorCategoriesModelToJson(
        List<RevenueSectorCategoriesFilteredModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RevenueSectorCategoriesFilteredModel {
  String id;
  String revenuesectorid;
  String typename;
  String typecode;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  RevenueSectorCategoriesFilteredModel({
    required this.id,
    required this.revenuesectorid,
    required this.typename,
    required this.typecode,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory RevenueSectorCategoriesFilteredModel.fromJson(
          Map<String, dynamic> json) =>
      RevenueSectorCategoriesFilteredModel(
        id: json["id"],
        revenuesectorid: json["revenuesectorid"],
        typename: json["typename"],
        typecode: json["typecode"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sectorid": revenuesectorid,
        "typename": typename,
        "typecode": typecode,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
