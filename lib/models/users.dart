// To parse this JSON data, do
//
//     final usersPaginatedModel = usersPaginatedModelFromJson(jsonString);

import 'dart:convert';

UsersPaginatedModel usersPaginatedModelFromJson(String str) =>
    UsersPaginatedModel.fromJson(json.decode(str));

String usersPaginatedModelToJson(UsersPaginatedModel data) =>
    json.encode(data.toJson());

class UsersPaginatedModel {
  List<UserItems> items;
  int total;
  int page;
  int size;
  int pages;

  UsersPaginatedModel({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory UsersPaginatedModel.fromJson(Map<String, dynamic> json) =>
      UsersPaginatedModel(
        items: List<UserItems>.from(
            json["items"].map((x) => UserItems.fromJson(x))),
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

class UserItems {
  String id;
  String? fcmid;
  String title;
  String firstname;
  String lastname;
  String? othernames;
  String phone;
  String? mobile;
  String email;
  String password;
  String? photo;
  String? villageid;
  String? parishid;
  String? subcountyid;
  String? countyid;
  String? districtid;
  String? nationality;
  dynamic tin;
  String? nin;
  String? passportno;
  dynamic revenuesource;
  String gender;
  dynamic isoperator;
  bool? isclerk;
  bool? isenforcer;
  bool? isadmin;
  bool? issuperadmin;
  DateTime? dateofbirth;
  DateTime datecreated;
  String? createdby;
  DateTime? dateupdated;
  String? updatedby;
  String status;

  UserItems({
    required this.id,
    required this.fcmid,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.othernames,
    required this.phone,
    required this.mobile,
    required this.email,
    required this.password,
    required this.photo,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    required this.districtid,
    required this.nationality,
    required this.tin,
    required this.nin,
    required this.passportno,
    required this.revenuesource,
    required this.gender,
    required this.isoperator,
    required this.isclerk,
    required this.isenforcer,
    required this.isadmin,
    required this.issuperadmin,
    required this.dateofbirth,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory UserItems.fromJson(Map<String, dynamic> json) => UserItems(
        id: json["id"],
        fcmid: json["fcmid"],
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
        isoperator: json["isoperator"],
        isclerk: json["isclerk"],
        isenforcer: json["isenforcer"],
        isadmin: json["isadmin"],
        issuperadmin: json["issuperadmin"],
        dateofbirth: json["dateofbirth"] == null
            ? null
            : DateTime.parse(json["dateofbirth"]),
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"] == null
            ? null
            : DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fcmid": fcmid,
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
        "isoperator": isoperator,
        "isclerk": isclerk,
        "isenforcer": isenforcer,
        "isadmin": isadmin,
        "issuperadmin": issuperadmin,
        "dateofbirth": dateofbirth?.toIso8601String(),
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated?.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
