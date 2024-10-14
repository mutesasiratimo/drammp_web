// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SmsResponse welcomeFromJson(String str) =>
    SmsResponse.fromJson(json.decode(str));

String welcomeToJson(SmsResponse data) => json.encode(data.toJson());

class SmsResponse {
  SmsResponse({
    required this.messageId,
    required this.status,
    required this.remarks,
  });

  int messageId;
  String status;
  String remarks;

  factory SmsResponse.fromJson(Map<String, dynamic> json) => SmsResponse(
        messageId: json["message_id"],
        status: json["status"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "status": status,
        "remarks": remarks,
      };
}
