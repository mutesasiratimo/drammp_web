// To parse this JSON data, do
//
//     final revenueSectorCategoriesModel = revenueSectorCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<RevenueSectorCategoriesModel> revenueSectorCategoriesModelFromJson(
        String str) =>
    List<RevenueSectorCategoriesModel>.from(
        json.decode(str).map((x) => RevenueSectorCategoriesModel.fromJson(x)));

String revenueSectorCategoriesModelToJson(
        List<RevenueSectorCategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RevenueSectorCategoriesModel {
  String id;
  Sectorid sectorid;
  String typename;
  String typecode;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  RevenueSectorCategoriesModel({
    required this.id,
    required this.sectorid,
    required this.typename,
    required this.typecode,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory RevenueSectorCategoriesModel.fromJson(Map<String, dynamic> json) =>
      RevenueSectorCategoriesModel(
        id: json["id"],
        sectorid: Sectorid.fromJson(json["sectorid"]),
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
        "sectorid": sectorid.toJson(),
        "typename": typename,
        "typecode": typecode,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}

class Sectorid {
  String id;
  String code;
  String name;
  String description;
  DateTime datecreated;
  dynamic createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  Sectorid({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory Sectorid.fromJson(Map<String, dynamic> json) => Sectorid(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
