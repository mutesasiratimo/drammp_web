// To parse this JSON data, do
//
//     final revenueSectorsModel = revenueSectorsModelFromJson(jsonString);

import 'dart:convert';

List<RevenueSectorsModel> revenueSectorsModelFromJson(String str) =>
    List<RevenueSectorsModel>.from(
        json.decode(str).map((x) => RevenueSectorsModel.fromJson(x)));

String revenueSectorsModelToJson(List<RevenueSectorsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RevenueSectorsModel {
  String id;
  String code;
  String name;
  String description;
  DateTime datecreated;
  dynamic createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  RevenueSectorsModel({
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

  factory RevenueSectorsModel.fromJson(Map<String, dynamic> json) =>
      RevenueSectorsModel(
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
