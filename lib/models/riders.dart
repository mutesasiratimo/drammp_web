// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Riders welcomeFromJson(String str) => Riders.fromJson(json.decode(str));

String welcomeToJson(Riders data) => json.encode(data.toJson());

class Riders {
  Riders({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
  });

  List<RiderItems> items;
  int total;
  int page;
  int size;

  factory Riders.fromJson(Map<String, dynamic> json) => Riders(
        items: List<RiderItems>.from(
            json["items"].map((x) => RiderItems.fromJson(x))),
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

class RiderItems {
  RiderItems({
    required this.id,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.othernames,
    required this.phone,
    required this.mobile,
    required this.email,
    required this.password,
    required this.gender,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    required this.districtid,
    required this.photo,
    required this.nationality,
    required this.nin,
    required this.passportno,
    this.permitno,
    this.trainingno,
    this.ninattach,
    this.residenceattach,
    this.stageattach,
    required this.dateofbirth,
    this.haspermit,
    this.istrained,
    this.createdby,
    this.updatedby,
    required this.status,
  });

  String id;
  String title;
  String firstname;
  String lastname;
  String othernames;
  String phone;
  String mobile;
  String email;
  String password;
  String gender;
  String villageid;
  String parishid;
  String subcountyid;
  String countyid;
  String districtid;
  String photo;
  String nationality;
  String nin;
  String passportno;
  dynamic permitno;
  dynamic trainingno;
  dynamic ninattach;
  dynamic residenceattach;
  dynamic stageattach;
  DateTime dateofbirth;
  dynamic haspermit;
  dynamic istrained;
  dynamic createdby;
  dynamic updatedby;
  String status;

  factory RiderItems.fromJson(Map<String, dynamic> json) => RiderItems(
        id: json["id"],
        title: json["title"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        othernames: json["othernames"],
        phone: json["phone"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
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
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "othernames": othernames,
        "phone": phone,
        "mobile": mobile,
        "email": email,
        "password": password,
        "gender": gender,
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
