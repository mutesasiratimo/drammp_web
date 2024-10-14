import 'dart:convert';

Authtoken welcomeFromJson(String str) => Authtoken.fromJson(json.decode(str));

String welcomeToJson(Authtoken data) => json.encode(data.toJson());

class Authtoken {
  Authtoken({
    required this.refresh,
    required this.access,
  });

  String refresh;
  String access;

  factory Authtoken.fromJson(Map<String, dynamic> json) => Authtoken(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
