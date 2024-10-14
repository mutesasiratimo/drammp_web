import 'dart:convert';

News welcomeFromJson(String str) => News.fromJson(json.decode(str));

String welcomeToJson(News data) => json.encode(data.toJson());

class News {
  News({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    this.file1,
    this.file2,
    this.file3,
    this.file4,
    this.file5,
    required this.datecreated,
    required this.createdby,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  String title;
  String content;
  String? image;
  String? file1;
  String? file2;
  String? file3;
  String? file4;
  String? file5;
  DateTime datecreated;
  String? createdby;
  DateTime? dateupdated;
  String? updatedby;
  String status;

  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        file1: json["file1"],
        file2: json["file2"],
        file3: json["file3"],
        file4: json["file4"],
        file5: json["file5"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"] != null
            ? DateTime.parse(json["dateupdated"])
            : DateTime.now(),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "image": image,
        "file1": file1,
        "file2": file2,
        "file3": file3,
        "file4": file4,
        "file5": file5,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated!.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
