// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Users welcomeFromJson(String str) => Users.fromJson(json.decode(str));

String welcomeToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
  });

  List<UserItem> items;
  int total;
  int page;
  int size;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        items:
            List<UserItem>.from(json["items"].map((x) => UserItem.fromJson(x))),
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

class UserItem {
  UserItem({
    required this.id,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.othernames,
    required this.phone,
    required this.mobile,
    required this.email,
    required this.password,
    required this.photo,
    this.villageid,
    this.parishid,
    this.subcountyid,
    this.countyid,
    this.districtid,
    this.nationality,
    this.tin,
    this.nin,
    this.passportno,
    this.revenuesource,
    required this.gender,
    this.isowner,
    this.isoperator,
    required this.isclerk,
    required this.isadmin,
    required this.issuperadmin,
    required this.dateofbirth,
    required this.datecreated,
    this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  String id;
  String title;
  String firstname;
  String lastname;
  dynamic othernames;
  String phone;
  String mobile;
  String email;
  String password;
  String photo;
  dynamic villageid;
  dynamic parishid;
  dynamic subcountyid;
  dynamic countyid;
  dynamic districtid;
  dynamic nationality;
  dynamic tin;
  dynamic nin;
  dynamic passportno;
  dynamic revenuesource;
  String gender;
  dynamic isowner;
  dynamic isoperator;
  bool isclerk;
  bool isadmin;
  bool issuperadmin;
  DateTime dateofbirth;
  DateTime datecreated;
  dynamic createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json["id"],
        title: json["title"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        othernames: json["othernames"],
        phone: json["phone"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        photo: json["photo"],
        villageid: json["villageid"],
        parishid: json["parishid"],
        subcountyid: json["subcountyid"],
        countyid: json["countyid"],
        districtid: json["districtid"],
        nationality: json["nationality"],
        tin: json["tin"],
        nin: json["nin"],
        passportno: json["passportno"],
        revenuesource: json["revenuesource"],
        gender: json["gender"],
        isowner: json["isowner"],
        isoperator: json["isoperator"],
        isclerk: json["isclerk"],
        isadmin: json["isadmin"],
        issuperadmin: json["issuperadmin"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"] == null
            ? null
            : DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"] ?? null,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "othernames": othernames,
        "phone": phone,
        "mobile": mobile,
        "email": email,
        "password": password,
        "photo": photo,
        "villageid": villageid,
        "parishid": parishid,
        "subcountyid": subcountyid,
        "countyid": countyid,
        "districtid": districtid,
        "nationality": nationality,
        "tin": tin,
        "nin": nin,
        "passportno": passportno,
        "revenuesource": revenuesource,
        "gender": gender,
        "isowner": isowner,
        "isoperator": isoperator,
        "isclerk": isclerk,
        "isadmin": isadmin,
        "issuperadmin": issuperadmin,
        "dateofbirth": dateofbirth.toIso8601String(),
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated":
            dateupdated == null ? null : dateupdated.toIso8601String(),
        "updatedby": updatedby == null ? null : updatedby,
        "status": status,
      };
}
