// To parse required this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CityReport welcomeFromJson(String str) => CityReport.fromJson(json.decode(str));

String welcomeToJson(CityReport data) => json.encode(data.toJson());

class CityReport {
  CityReport({
    required this.id,
    required this.name,
    required this.description,
    required this.reporttype,
    required this.reference,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.isemergency,
    required this.attachment,
    required this.likes,
    required this.dislikes,
    required this.commentscount,
    required this.datecreated,
    required this.createdby,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  String name;
  String description;
  String reporttype;
  String reference;
  String address;
  double addresslat;
  double addresslong;
  bool isemergency;
  String attachment;
  int likes;
  int dislikes;
  int commentscount;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory CityReport.fromJson(Map<String, dynamic> json) => CityReport(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        reporttype: json["reporttype"],
        reference: json["reference"],
        address: json["address"],
        addresslat: json["addresslat"].toDouble(),
        addresslong: json["addresslong"].toDouble(),
        isemergency: json["isemergency"],
        attachment: json["attachment"],
        likes: json["likes"],
        dislikes: json["dislikes"],
        commentscount: json["commentscount"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "reporttype": reporttype,
        "reference": reference,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "isemergency": isemergency,
        "attachment": attachment,
        "likes": likes,
        "dislikes": dislikes,
        "commentscount": commentscount,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
