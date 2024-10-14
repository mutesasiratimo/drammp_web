// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ProfileModel welcomeFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String welcomeToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.isCitizen,
    required this.isDataEntrant,
    required this.isManager,
    required this.isDdt,
    required this.fullName,
    required this.displayRole,
    required this.profile,
    required this.incidentsCount,
    required this.lastLogin,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.surname,
    required this.gender,
  });

  int id;
  bool isCitizen;
  bool isDataEntrant;
  bool isManager;
  bool isDdt;
  String fullName;
  String displayRole;
  Profile profile;
  int incidentsCount;
  DateTime lastLogin;
  String username;
  String firstName;
  String lastName;
  String email;
  bool isStaff;
  bool isActive;
  DateTime dateJoined;
  String surname;
  String gender;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        isCitizen: json["is_citizen"],
        isDataEntrant: json["is_data_entrant"],
        isManager: json["is_manager"],
        isDdt: json["is_ddt"],
        fullName: json["full_name"],
        displayRole: json["display_role"],
        profile: Profile.fromJson(json["profile"]),
        incidentsCount: json["incidents_count"],
        lastLogin: DateTime.parse(json["last_login"]),
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        surname: json["surname"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_citizen": isCitizen,
        "is_data_entrant": isDataEntrant,
        "is_manager": isManager,
        "is_ddt": isDdt,
        "full_name": fullName,
        "display_role": displayRole,
        "profile": profile.toJson(),
        "incidents_count": incidentsCount,
        "last_login": lastLogin.toIso8601String(),
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "surname": surname,
        "gender": gender,
      };
}

class Profile {
  Profile({
    required this.id,
    this.homeAddress,
    this.workAddress,
    required this.createdOn,
    required this.updatedOn,
    required this.nationality,
    required this.nin,
    required this.mobileNumber,
    required this.mobileNumber2,
    required this.headOfDepartment,
    this.address,
    this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    required this.verified,
    required this.division,
    required this.department,
    required this.designation,
    this.language,
  });

  String id;
  dynamic homeAddress;
  dynamic workAddress;
  DateTime createdOn;
  DateTime updatedOn;
  int nationality;
  String nin;
  String mobileNumber;
  String mobileNumber2;
  bool headOfDepartment;
  dynamic address;
  dynamic dateOfBirth;
  String idType;
  String idNumber;
  bool verified;
  String division;
  String department;
  String designation;
  dynamic language;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        homeAddress: json["home_address"],
        workAddress: json["work_address"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        nationality: json["nationality"],
        nin: json["nin"],
        mobileNumber: json["mobile_number"],
        mobileNumber2: json["mobile_number_2"],
        headOfDepartment: json["head_of_department"],
        address: json["address"],
        dateOfBirth: json["date_of_birth"],
        idType: json["id_type"],
        idNumber: json["id_number"],
        verified: json["verified"],
        division: json["division"],
        department: json["department"],
        designation: json["designation"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "home_address": homeAddress,
        "work_address": workAddress,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "nationality": nationality,
        "nin": nin,
        "mobile_number": mobileNumber,
        "mobile_number_2": mobileNumber2,
        "head_of_department": headOfDepartment,
        "address": address,
        "date_of_birth": dateOfBirth,
        "id_type": idType,
        "id_number": idNumber,
        "verified": verified,
        "division": division,
        "department": department,
        "designation": designation,
        "language": language,
      };
}
