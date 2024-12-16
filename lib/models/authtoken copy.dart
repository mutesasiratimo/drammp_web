// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AuthToken welcomeFromJson(String str) => AuthToken.fromJson(json.decode(str));

String welcomeToJson(AuthToken data) => json.encode(data.toJson());

class AuthToken {
  AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  String accessToken;
  String tokenType;
  int expiresIn;

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}
