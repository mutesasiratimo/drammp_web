// To parse this JSON data, do
//
//     final tripsPaginatedModel = tripsPaginatedModelFromJson(jsonString);

import 'dart:convert';

TripsPaginatedModel tripsPaginatedModelFromJson(String str) =>
    TripsPaginatedModel.fromJson(json.decode(str));

String tripsPaginatedModelToJson(TripsPaginatedModel data) =>
    json.encode(data.toJson());

class TripsPaginatedModel {
  List<TripModel> items;
  int total;
  int page;
  int size;
  int pages;

  TripsPaginatedModel({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory TripsPaginatedModel.fromJson(Map<String, dynamic> json) =>
      TripsPaginatedModel(
        items: List<TripModel>.from(
            json["items"].map((x) => TripModel.fromJson(x))),
        total: json["total"],
        page: json["page"],
        size: json["size"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total": total,
        "page": page,
        "size": size,
        "pages": pages,
      };
}

class TripModel {
  String id;
  dynamic tripnumber;
  String startaddress;
  double startlat;
  double startlong;
  String startstageid;
  String vehicleid;
  String passengerid;
  DateTime starttime;
  String destinationaddress;
  double destinationlat;
  double destinationlong;
  String stopstageid;
  DateTime stoptime;
  String transporttypeid;
  String paymentstatus;
  double cost;
  DateTime datecreated;
  String createdby;
  DateTime dateupdated;
  String updatedby;
  String status;

  TripModel({
    required this.id,
    this.tripnumber,
    required this.startaddress,
    required this.startlat,
    required this.startlong,
    required this.startstageid,
    required this.vehicleid,
    required this.passengerid,
    required this.starttime,
    required this.destinationaddress,
    required this.destinationlat,
    required this.destinationlong,
    required this.stopstageid,
    required this.stoptime,
    required this.transporttypeid,
    required this.paymentstatus,
    required this.cost,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"],
        tripnumber: json["tripnumber"],
        startaddress: json["startaddress"],
        startlat: json["startlat"]?.toDouble(),
        startlong: json["startlong"]?.toDouble(),
        startstageid: json["startstageid"],
        vehicleid: json["vehicleid"],
        passengerid: json["passengerid"],
        starttime: DateTime.parse(json["starttime"]),
        destinationaddress: json["destinationaddress"],
        destinationlat: json["destinationlat"]?.toDouble(),
        destinationlong: json["destinationlong"]?.toDouble(),
        stopstageid: json["stopstageid"],
        stoptime: DateTime.parse(json["stoptime"]),
        transporttypeid: json["transporttypeid"],
        paymentstatus: json["paymentstatus"],
        cost: json["cost"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripnumber": tripnumber,
        "startaddress": startaddress,
        "startlat": startlat,
        "startlong": startlong,
        "startstageid": startstageid,
        "vehicleid": vehicleid,
        "passengerid": passengerid,
        "starttime": starttime.toIso8601String(),
        "destinationaddress": destinationaddress,
        "destinationlat": destinationlat,
        "destinationlong": destinationlong,
        "stopstageid": stopstageid,
        "stoptime": stoptime.toIso8601String(),
        "transporttypeid": transporttypeid,
        "paymentstatus": paymentstatus,
        "cost": cost,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
