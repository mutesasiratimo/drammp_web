// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Languages welcomeFromJson(String str) => Languages.fromJson(json.decode(str));

String welcomeToJson(Languages data) => json.encode(data.toJson());

class Languages {
  Languages({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.createdOn,
    required this.updatedOn,
    required this.name,
  });

  String id;
  DateTime createdOn;
  DateTime updatedOn;
  String name;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "name": name,
      };
}
