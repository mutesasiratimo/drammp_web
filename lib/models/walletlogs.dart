// To parse this JSON data, do
//
//     final walletLogsModel = walletLogsModelFromJson(jsonString);

import 'dart:convert';

List<WalletLogsModel> walletLogsModelFromJson(String str) =>
    List<WalletLogsModel>.from(
        json.decode(str).map((x) => WalletLogsModel.fromJson(x)));

String walletLogsModelToJson(List<WalletLogsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalletLogsModel {
  String id;
  UserModel userid;
  String userwalletid;
  double amount;
  String type;
  String description;
  DateTime datecreated;
  dynamic createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  WalletLogsModel({
    required this.id,
    required this.userid,
    required this.userwalletid,
    required this.amount,
    required this.type,
    required this.description,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory WalletLogsModel.fromJson(Map<String, dynamic> json) =>
      WalletLogsModel(
        id: json["id"],
        userid: UserModel.fromJson(json["userid"]),
        userwalletid: json["userwalletid"],
        amount: json["amount"],
        type: json["type"],
        description: json["description"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid.toJson(),
        "userwalletid": userwalletid,
        "amount": amount,
        "type": type,
        "description": description,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}

class UserModel {
  String id;
  String title;
  String fcmid;
  String firstname;
  String lastname;
  dynamic othernames;
  String email;
  String phone;
  dynamic mobile;
  dynamic dateofbirth;
  String password;
  String gender;
  dynamic photo;
  bool issuperadmin;
  bool isadmin;
  bool isclerk;
  bool isenforcer;
  dynamic isindividual;
  dynamic nationality;
  dynamic tin;
  dynamic nin;
  dynamic brn;
  dynamic entitytype;
  dynamic passportno;
  dynamic address;
  dynamic addresslat;
  dynamic addresslong;
  dynamic villageid;
  dynamic parishid;
  dynamic subcountyid;
  dynamic countyid;
  dynamic districtid;
  DateTime datecreated;
  dynamic createdby;
  DateTime dateupdated;
  String? updatedby;
  String status;

  UserModel({
    required this.id,
    required this.title,
    required this.fcmid,
    required this.firstname,
    required this.lastname,
    required this.othernames,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.dateofbirth,
    required this.password,
    required this.gender,
    required this.photo,
    required this.issuperadmin,
    required this.isadmin,
    required this.isclerk,
    required this.isenforcer,
    required this.isindividual,
    required this.nationality,
    required this.tin,
    required this.nin,
    required this.brn,
    required this.entitytype,
    required this.passportno,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    required this.districtid,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        title: json["title"],
        fcmid: json["fcmid"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        othernames: json["othernames"],
        email: json["email"],
        phone: json["phone"],
        mobile: json["mobile"],
        dateofbirth: json["dateofbirth"],
        password: json["password"],
        gender: json["gender"],
        photo: json["photo"],
        issuperadmin: json["issuperadmin"],
        isadmin: json["isadmin"],
        isclerk: json["isclerk"],
        isenforcer: json["isenforcer"],
        isindividual: json["isindividual"],
        nationality: json["nationality"],
        tin: json["tin"],
        nin: json["nin"],
        brn: json["brn"],
        entitytype: json["entitytype"],
        passportno: json["passportno"],
        address: json["address"],
        addresslat: json["addresslat"],
        addresslong: json["addresslong"],
        villageid: json["villageid"],
        parishid: json["parishid"],
        subcountyid: json["subcountyid"],
        countyid: json["countyid"],
        districtid: json["districtid"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "fcmid": fcmid,
        "firstname": firstname,
        "lastname": lastname,
        "othernames": othernames,
        "email": email,
        "phone": phone,
        "mobile": mobile,
        "dateofbirth": dateofbirth,
        "password": password,
        "gender": gender,
        "photo": photo,
        "issuperadmin": issuperadmin,
        "isadmin": isadmin,
        "isclerk": isclerk,
        "isenforcer": isenforcer,
        "isindividual": isindividual,
        "nationality": nationality,
        "tin": tin,
        "nin": nin,
        "brn": brn,
        "entitytype": entitytype,
        "passportno": passportno,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "villageid": villageid,
        "parishid": parishid,
        "subcountyid": subcountyid,
        "countyid": countyid,
        "districtid": districtid,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
