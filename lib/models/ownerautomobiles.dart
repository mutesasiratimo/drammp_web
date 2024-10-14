// To parse this JSON data, do
//
//     final ownerAutomobiles = ownerAutomobilesFromJson(jsonString);

import 'dart:convert';

OwnerAutomobiles ownerAutomobilesFromJson(String str) =>
    OwnerAutomobiles.fromJson(json.decode(str));

String ownerAutomobilesToJson(OwnerAutomobiles data) =>
    json.encode(data.toJson());

class OwnerAutomobiles {
  OwnerAutomobiles({
    required this.id,
    this.regreferenceno,
    required this.transporttypeid,
    required this.regno,
    required this.vin,
    required this.color,
    this.logbookno,
    this.engineno,
    this.model,
    required this.ownerid,
    required this.operatorid,
    required this.divisionid,
    required this.stageid,
    required this.datecreated,
    required this.createdby,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  dynamic regreferenceno;
  String transporttypeid;
  String regno;
  String vin;
  String color;
  dynamic logbookno;
  dynamic engineno;
  dynamic model;
  String ownerid;
  String operatorid;
  String divisionid;
  String stageid;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory OwnerAutomobiles.fromJson(Map<String, dynamic> json) =>
      OwnerAutomobiles(
        id: json["id"],
        regreferenceno: json["regreferenceno"],
        transporttypeid: json["transporttypeid"],
        regno: json["regno"],
        vin: json["vin"],
        color: json["color"],
        logbookno: json["logbookno"],
        engineno: json["engineno"],
        model: json["model"],
        ownerid: json["ownerid"],
        operatorid: json["operatorid"],
        divisionid: json["divisionid"],
        stageid: json["stageid"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regreferenceno": regreferenceno,
        "transporttypeid": transporttypeid,
        "regno": regno,
        "vin": vin,
        "color": color,
        "logbookno": logbookno,
        "engineno": engineno,
        "model": model,
        "ownerid": ownerid,
        "operatorid": operatorid,
        "divisionid": divisionid,
        "stageid": stageid,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
