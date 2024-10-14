// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Owners welcomeFromJson(String str) => Owners.fromJson(json.decode(str));

String welcomeToJson(Owners data) => json.encode(data.toJson());

class Owners {
  Owners({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
  });

  List<OwnerItem> items;
  int total;
  int page;
  int size;

  factory Owners.fromJson(Map<String, dynamic> json) => Owners(
        items: List<OwnerItem>.from(
            json["items"].map((x) => OwnerItem.fromJson(x))),
        total: json["total"],
        page: json["page"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total": total,
        "page": page,
        "size": size,
      };
}

class OwnerItem {
  OwnerItem({
    required this.id,
    this.title,
    this.firstname,
    this.lastname,
    this.othernames,
    this.legalname,
    this.brn,
    this.tin,
    required this.phone,
    required this.mobile,
    required this.email,
    // required this.password,
    // required this.photo,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    this.nin,
    required this.districtid,
    // required this.address,
    // required this.addresslat,
    // required this.addresslong,
    this.entitytype,
    // required this.revenuesource,
    this.dateestablished,
    this.dateofbirth,
    required this.isindividual,
    required this.datecreated,
    this.createdby,
    // this.dateupdated,
    // this.updatedby,
    required this.status,
  });

  String id;
  dynamic title;
  dynamic firstname;
  dynamic lastname;
  dynamic othernames;
  dynamic legalname;
  dynamic brn;
  dynamic tin;
  String phone;
  dynamic nin;
  dynamic mobile;
  String email;
  // String password;
  // String photo;
  String villageid;
  String parishid;
  String subcountyid;
  String countyid;
  String districtid;
  // String address;
  // double addresslat;
  // double addresslong;
  dynamic entitytype;
  // String revenuesource;
  dynamic dateestablished;
  dynamic dateofbirth;
  bool isindividual;
  DateTime datecreated;
  dynamic createdby;
  // dynamic dateupdated;
  // dynamic updatedby;
  String status;

  factory OwnerItem.fromJson(Map<String, dynamic> json) => OwnerItem(
        id: json["id"],
        title: json["title"] == null ? null : json["title"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        othernames: json["othernames"] == null ? null : json["othernames"],
        legalname: json["legalname"] == null ? null : json["legalname"],
        brn: json["brn"] == null ? null : json["brn"],
        nin: json["nin"] == null ? null : json["nin"],
        tin: json["tin"],
        phone: json["phone"],
        mobile: json["mobile"],
        email: json["email"],
        // password: json["password"],
        // photo: json["photo"],
        villageid: json["villageid"],
        parishid: json["parishid"],
        subcountyid: json["subcountyid"],
        countyid: json["countyid"],
        districtid: json["districtid"],
        // address: json["address"],
        // addresslat: json["addresslat"].toDouble(),
        // addresslong: json["addresslong"].toDouble(),
        entitytype: json["entitytype"] == null ? null : json["entitytype"],
        // revenuesource: json["revenuesource"],
        dateestablished: json["dateestablished"] == null
            ? null
            : DateTime.parse(json["dateestablished"]),
        dateofbirth: json["dateofbirth"] == null
            ? null
            : DateTime.parse(json["dateofbirth"]),
        isindividual: json["isindividual"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"] == null ? null : json["createdby"],
        // dateupdated: json["dateupdated"],
        // updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title == null ? null : title,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "othernames": othernames == null ? null : othernames,
        "legalname": legalname == null ? null : legalname,
        "brn": brn == null ? null : brn,
        "nin": nin == null ? null : nin,
        "tin": tin,
        "phone": phone,
        "mobile": mobile,
        "email": email,
        // "password": password,
        // "photo": photo,
        "villageid": villageid,
        "parishid": parishid,
        "subcountyid": subcountyid,
        "countyid": countyid,
        "districtid": districtid,
        // "address": address,
        // "addresslat": addresslat,
        // "addresslong": addresslong,
        "entitytype": entitytype == null ? null : entitytype,
        // "revenuesource": revenuesource,
        "dateestablished":
            dateestablished == null ? null : dateestablished.toIso8601String(),
        "dateofbirth":
            dateofbirth == null ? null : dateofbirth.toIso8601String(),
        "isindividual": isindividual,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        // "dateupdated": dateupdated,
        // "updatedby": updatedby,
        "status": status,
      };
}
