// To parse this JSON data, do
//
//     final tripHistory = tripHistoryFromJson(jsonString);

import 'dart:convert';

TripHistorys tripHistoryFromJson(String str) =>
    TripHistorys.fromJson(json.decode(str));

String tripHistoryToJson(TripHistorys data) => json.encode(data.toJson());

class TripHistorys {
  TripHistorys({
    required this.id,
    required this.startaddress,
    required this.startlat,
    required this.startlong,
    required this.destinationaddress,
    required this.destinationlat,
    required this.destinationlong,
    required this.datecreated,
    required this.createdby,
    // this.dateupdated,
    // this.updatedby,
    required this.status,
  });

  String id;
  String startaddress;
  double startlat;
  double startlong;
  String destinationaddress;
  double destinationlat;
  double destinationlong;
  DateTime datecreated;
  String createdby;
  // dynamic dateupdated;
  // dynamic updatedby;
  String status;

  factory TripHistorys.fromJson(Map<String, dynamic> json) => TripHistorys(
        id: json["id"],
        startaddress: json["startaddress"],
        startlat: json["startlat"],
        startlong: json["startlong"],
        destinationaddress: json["destinationaddress"],
        destinationlat: json["destinationlat"],
        destinationlong: json["destinationlong"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        // dateupdated: DateTime.parse(json["dateupdated"]),
        // updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startaddress": startaddress,
        "startlat": startlat,
        "startlong": startlong,
        "destinationaddress": destinationaddress,
        "destinationlat": destinationlat,
        "destinationlong": destinationlong,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        // "dateupdated": dateupdated!.toIso8601String(),
        // "updatedby": updatedby,
        "status": status,
      };
}
