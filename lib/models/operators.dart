// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

OperatorsModel welcomeFromJson(String str) =>
    OperatorsModel.fromJson(json.decode(str));

String welcomeToJson(OperatorsModel data) => json.encode(data.toJson());

class OperatorsModel {
  List<Item> items;
  int total;
  int page;
  int size;
  int pages;

  OperatorsModel({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory OperatorsModel.fromJson(Map<String, dynamic> json) => OperatorsModel(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
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

class Item {
  String id;
  String fcmid;
  String title;
  String firstname;
  String lastname;
  String othernames;
  String phone;
  String mobile;
  String email;
  String password;
  dynamic gender;
  dynamic modeofops;
  dynamic eplatform;
  dynamic villageid;
  dynamic parishid;
  dynamic subcountyid;
  dynamic countyid;
  dynamic districtid;
  dynamic photo;
  dynamic nationality;
  dynamic nin;
  dynamic passportno;
  dynamic permitno;
  dynamic trainingno;
  dynamic ninattach;
  dynamic residenceattach;
  dynamic stageattach;
  DateTime dateofbirth;
  dynamic haspermit;
  dynamic istrained;
  String createdby;
  dynamic updatedby;
  String status;

  Item({
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
    required this.gender,
    required this.modeofops,
    required this.eplatform,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    required this.districtid,
    required this.photo,
    required this.nationality,
    required this.nin,
    required this.passportno,
    required this.permitno,
    required this.trainingno,
    required this.ninattach,
    required this.residenceattach,
    required this.stageattach,
    required this.dateofbirth,
    required this.haspermit,
    required this.istrained,
    required this.createdby,
    required this.updatedby,
    required this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
        gender: json["gender"],
        modeofops: json["modeofops"],
        eplatform: json["eplatform"],
        villageid: json["villageid"],
        parishid: json["parishid"],
        subcountyid: json["subcountyid"],
        countyid: json["countyid"],
        districtid: json["districtid"],
        photo: json["photo"],
        nationality: json["nationality"],
        nin: json["nin"],
        passportno: json["passportno"],
        permitno: json["permitno"],
        trainingno: json["trainingno"],
        ninattach: json["ninattach"],
        residenceattach: json["residenceattach"],
        stageattach: json["stageattach"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        haspermit: json["haspermit"],
        istrained: json["istrained"],
        createdby: json["createdby"],
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
        "gender": gender,
        "modeofops": modeofops,
        "eplatform": eplatform,
        "villageid": villageid,
        "parishid": parishid,
        "subcountyid": subcountyid,
        "countyid": countyid,
        "districtid": districtid,
        "photo": photo,
        "nationality": nationality,
        "nin": nin,
        "passportno": passportno,
        "permitno": permitno,
        "trainingno": trainingno,
        "ninattach": ninattach,
        "residenceattach": residenceattach,
        "stageattach": stageattach,
        "dateofbirth": dateofbirth.toIso8601String(),
        "haspermit": haspermit,
        "istrained": istrained,
        "createdby": createdby,
        "updatedby": updatedby,
        "status": status,
      };
}
