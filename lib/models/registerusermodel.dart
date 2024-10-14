// To parse this JSON data, do
//
//     final automobiles = automobilesFromJson(jsonString);

import 'dart:convert';

UserRegister automobilesFromJson(String str) =>
    UserRegister.fromJson(json.decode(str));

String automobilesToJson(UserRegister data) => json.encode(data.toJson());

class UserRegister {
  UserRegister({
    required this.id,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.email,
    required this.password,
    // this.cardid,
    required this.isadmin,
    required this.isclerk,
    required this.issuperadmin,
    required this.status,
    required this.token,
  });

  String id;
  String title;
  String firstname;
  String lastname;
  String phone;
  String email;
  String password;
  // dynamic cardid;
  bool isadmin;
  bool isclerk;
  bool issuperadmin;
  String status;
  String token;

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        id: json["id"],
        title: json["title"].toString(),
        firstname: json["firstname"].toString(),
        lastname: json["lastname"].toString(),
        phone: json["phone"].toString(),
        email: json["email"].toString(),
        password: json["password"],
        isadmin: json["isadmin"],
        isclerk: json["isclerk"],
        issuperadmin: json["issuperadmin"],
        status: json["status"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "email": email,
        "password": password,
        "isadmin": isadmin,
        "isclerk": isclerk,
        "issuperadmin": issuperadmin,
        "status": status,
      };
}
