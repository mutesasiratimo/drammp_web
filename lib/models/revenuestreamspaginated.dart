// To parse this JSON data, do
//
//     final revenueStreamsPaginatedModel = revenueStreamsPaginatedModelFromJson(jsonString);

import 'dart:convert';

RevenueStreamsPaginatedModel revenueStreamsPaginatedModelFromJson(String str) =>
    RevenueStreamsPaginatedModel.fromJson(json.decode(str));

String revenueStreamsPaginatedModelToJson(RevenueStreamsPaginatedModel data) =>
    json.encode(data.toJson());

class RevenueStreamsPaginatedModel {
  List<RevenueStreams> items;
  int total;
  int page;
  int size;
  int pages;

  RevenueStreamsPaginatedModel({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory RevenueStreamsPaginatedModel.fromJson(Map<String, dynamic> json) =>
      RevenueStreamsPaginatedModel(
        items: List<RevenueStreams>.from(
            json["items"].map((x) => RevenueStreams.fromJson(x))),
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

class RevenueStreams {
  String id;
  String regreferenceno;
  String sectorid;
  String sectorsubtypeid;
  String tarriffrequency;
  int tarrifamount;
  DateTime lastrenewaldate;
  DateTime nextrenewaldate;
  String revenueactivity;
  String vesseltype;
  String vesselstorage;
  String vesselmaterial;
  String vesselsafetyequip;
  int vessellength;
  String vesselpropulsion;
  int dailyactivehours;
  String companytype;
  String businesstype;
  String businessname;
  String tradingname;
  int staffcountmale;
  int staffcountfemale;
  int bedcount;
  int roomcount;
  bool hasbar;
  bool hasrestaurant;
  bool hasgym;
  bool hashealthclub;
  bool haspool;
  bool hasconference;
  String establishmenttype;
  String regno;
  String vin;
  String tin;
  dynamic brn;
  String color;
  String ownerid;
  String operatorid;
  String logbookno;
  String engineno;
  String model;
  String divisionid;
  String stageid;
  dynamic address;
  dynamic addresslat;
  dynamic addresslong;
  String? purpose;
  String type;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  RevenueStreams({
    required this.id,
    required this.regreferenceno,
    required this.sectorid,
    required this.sectorsubtypeid,
    required this.tarriffrequency,
    required this.tarrifamount,
    required this.lastrenewaldate,
    required this.nextrenewaldate,
    required this.revenueactivity,
    required this.vesseltype,
    required this.vesselstorage,
    required this.vesselmaterial,
    required this.vesselsafetyequip,
    required this.vessellength,
    required this.vesselpropulsion,
    required this.dailyactivehours,
    required this.companytype,
    required this.businesstype,
    required this.businessname,
    required this.tradingname,
    required this.staffcountmale,
    required this.staffcountfemale,
    required this.bedcount,
    required this.roomcount,
    required this.hasbar,
    required this.hasrestaurant,
    required this.hasgym,
    required this.hashealthclub,
    required this.haspool,
    required this.hasconference,
    required this.establishmenttype,
    required this.regno,
    required this.vin,
    required this.tin,
    this.brn,
    required this.color,
    required this.ownerid,
    required this.operatorid,
    required this.logbookno,
    required this.engineno,
    required this.model,
    required this.divisionid,
    required this.stageid,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.purpose,
    required this.type,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory RevenueStreams.fromJson(Map<String, dynamic> json) => RevenueStreams(
        id: json["id"],
        regreferenceno: json["regreferenceno"],
        sectorid: json["sectorid"],
        sectorsubtypeid: json["sectorsubtypeid"],
        tarriffrequency: json["tarriffrequency"],
        tarrifamount: json["tarrifamount"],
        lastrenewaldate: DateTime.parse(json["lastrenewaldate"]),
        nextrenewaldate: DateTime.parse(json["nextrenewaldate"]),
        revenueactivity: json["revenueactivity"],
        vesseltype: json["vesseltype"],
        vesselstorage: json["vesselstorage"],
        vesselmaterial: json["vesselmaterial"],
        vesselsafetyequip: json["vesselsafetyequip"],
        vessellength: json["vessellength"],
        vesselpropulsion: json["vesselpropulsion"],
        dailyactivehours: json["dailyactivehours"],
        companytype: json["companytype"],
        businesstype: json["businesstype"],
        businessname: json["businessname"],
        tradingname: json["tradingname"],
        staffcountmale: json["staffcountmale"],
        staffcountfemale: json["staffcountfemale"],
        bedcount: json["bedcount"],
        roomcount: json["roomcount"],
        hasrestaurant: json["hasrestaurant"],
        hasbar: json["hasbar"],
        hasgym: json["hasgym"],
        hashealthclub: json["hashealthclub"],
        hasconference: json["hasconference"],
        haspool: json["haspool"],
        establishmenttype: json["establishmenttype"],
        regno: json["regno"],
        vin: json["vin"],
        tin: json["tin"],
        brn: json["brn"],
        color: json["color"],
        ownerid: json["ownerid"],
        operatorid: json["operatorid"],
        logbookno: json["logbookno"],
        engineno: json["engineno"],
        model: json["model"],
        divisionid: json["divisionid"],
        stageid: json["stageid"],
        address: json["address"],
        addresslat: json["addresslat"],
        addresslong: json["addresslong"],
        purpose: json["purpose"],
        type: json["type"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regreferenceno": regreferenceno,
        "sectorid": sectorid,
        "sectorsubtypeid": sectorsubtypeid,
        "tarriffrequency": tarriffrequency,
        "tarrifamount": tarrifamount,
        "lastrenewaldate": lastrenewaldate.toIso8601String(),
        "nextrenewaldate": nextrenewaldate.toIso8601String(),
        "revenueactivity": revenueactivity,
        "vesseltype": vesseltype,
        "vesselstorage": vesselstorage,
        "vesselmaterial": vesselmaterial,
        "vesselsafetyequip": vesselsafetyequip,
        "vessellength": vessellength,
        "vesselpropulsion": vesselpropulsion,
        "dailyactivehours": dailyactivehours,
        "companytype": companytype,
        "businesstype": businesstype,
        "businessname": businessname,
        "tradingname": tradingname,
        "staffcountmale": staffcountmale,
        "staffcountfemale": staffcountfemale,
        "bedcount": bedcount,
        "roomcount": roomcount,
        "hasgym": hasgym,
        "hashealthclub": hashealthclub,
        "haspool": haspool,
        "hasbar": hasbar,
        "hasresataurant": hasrestaurant,
        "hasconference": hasconference,
        "establishmenttype": establishmenttype,
        "regno": regno,
        "vin": vin,
        "tin": tin,
        "brn": brn,
        "color": color,
        "ownerid": ownerid,
        "operatorid": operatorid,
        "logbookno": logbookno,
        "engineno": engineno,
        "model": model,
        "divisionid": divisionid,
        "stageid": stageid,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "purpose": purpose,
        "type": type,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
