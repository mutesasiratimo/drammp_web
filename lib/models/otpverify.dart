// To parse this JSON data, do
//
//     final otpVerify = otpVerifyFromJson(jsonString);

import 'dart:convert';

OtpVerify otpVerifyFromJson(String str) => OtpVerify.fromJson(json.decode(str));

String otpVerifyToJson(OtpVerify data) => json.encode(data.toJson());

class OtpVerify {
  int failed;
  int total;
  List<Detail> detail;
  int submitted;

  OtpVerify({
    required this.failed,
    required this.total,
    required this.detail,
    required this.submitted,
  });

  factory OtpVerify.fromJson(Map<String, dynamic> json) => OtpVerify(
        failed: json["Failed"],
        total: json["Total"],
        detail:
            List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
        submitted: json["Submitted"],
      );

  Map<String, dynamic> toJson() => {
        "Failed": failed,
        "Total": total,
        "Detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "Submitted": submitted,
      };
}

class Detail {
  String phone;
  int msgId;

  Detail({
    required this.phone,
    required this.msgId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        phone: json["phone"],
        msgId: json["msg_id"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "msg_id": msgId,
      };
}
