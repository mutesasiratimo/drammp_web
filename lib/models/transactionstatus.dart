// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TransactionStatus welcomeFromJson(String str) =>
    TransactionStatus.fromJson(json.decode(str));

String welcomeToJson(TransactionStatus data) => json.encode(data.toJson());

class TransactionStatus {
  TransactionStatus({
    required this.amount,
    required this.currency,
    required this.financialTransactionId,
    required this.externalId,
    required this.payer,
    required this.status,
  });

  int amount;
  String currency;
  int financialTransactionId;
  int externalId;
  Payer payer;
  String status;

  factory TransactionStatus.fromJson(Map<String, dynamic> json) =>
      TransactionStatus(
        amount: json["amount"],
        currency: json["currency"],
        financialTransactionId: json["financialTransactionId"],
        externalId: json["externalId"],
        payer: Payer.fromJson(json["payer"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
        "financialTransactionId": financialTransactionId,
        "externalId": externalId,
        "payer": payer.toJson(),
        "status": status,
      };
}

class Payer {
  Payer({
    required this.partyIdType,
    required this.partyId,
  });

  String partyIdType;
  int partyId;

  factory Payer.fromJson(Map<String, dynamic> json) => Payer(
        partyIdType: json["partyIdType"],
        partyId: json["partyId"],
      );

  Map<String, dynamic> toJson() => {
        "partyIdType": partyIdType,
        "partyId": partyId,
      };
}
/////////////////////////// AIRTEL TRANSACTION STATUS ////////////////////

AirtelTransactionStatus airtelTransactionStatusFromJson(String str) =>
    AirtelTransactionStatus.fromJson(json.decode(str));

String airtelTransactionStatusToJson(AirtelTransactionStatus data) =>
    json.encode(data.toJson());

class AirtelTransactionStatus {
  AirtelTransactionStatus({
    required this.data,
    required this.status,
  });

  Data data;
  Status status;

  factory AirtelTransactionStatus.fromJson(Map<String, dynamic> json) =>
      AirtelTransactionStatus(
        data: Data.fromJson(json["data"]),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status.toJson(),
      };
}

class Data {
  Data({
    required this.transaction,
  });

  Transaction transaction;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transaction: Transaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction": transaction.toJson(),
      };
}

class Transaction {
  Transaction({
    required this.id,
    required this.status,
  });

  String id;
  String status;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}

class Status {
  Status({
    required this.code,
    required this.message,
    required this.resultCode,
    required this.responseCode,
    required this.success,
  });

  String code;
  String message;
  String resultCode;
  String responseCode;
  bool success;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        message: json["message"],
        resultCode: json["result_code"],
        responseCode: json["response_code"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result_code": resultCode,
        "response_code": responseCode,
        "success": success,
      };
}
