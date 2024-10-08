// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String? status;
    String? userToken;
    User? user;
    Organizations? organizations;

    LoginModel({
        this.status,
        this.userToken,
        this.user,
        this.organizations,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        userToken: json["user_token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        organizations: json["organizations"] == null ? null : Organizations.fromJson(json["organizations"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "user_token": userToken,
        "user": user?.toJson(),
        "organizations": organizations?.toJson(),
    };
}

class Organizations {
    Organizations();

    factory Organizations.fromJson(Map<String, dynamic> json) => Organizations(
    );

    Map<String, dynamic> toJson() => {
    };
}

class User {
    int? id;
    String? firstName;
    String? lastName;
    String? email;
    dynamic facebookId;
    dynamic avatar;
    String? role;
    dynamic phone;
    String? address;
    dynamic emailVerifiedAt;
    int? status;
    dynamic meta;
    dynamic plan;
    dynamic planId;
    dynamic willExpire;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;
    String? fullName;

    User({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.facebookId,
        this.avatar,
        this.role,
        this.phone,
        this.address,
        this.emailVerifiedAt,
        this.status,
        this.meta,
        this.plan,
        this.planId,
        this.willExpire,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.fullName,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        facebookId: json["facebook_id"],
        avatar: json["avatar"],
        role: json["role"],
        phone: json["phone"],
        address: json["address"],
        emailVerifiedAt: json["email_verified_at"],
        status: json["status"],
        meta: json["meta"],
        plan: json["plan"],
        planId: json["plan_id"],
        willExpire: json["will_expire"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        fullName: json["full_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "facebook_id": facebookId,
        "avatar": avatar,
        "role": role,
        "phone": phone,
        "address": address,
        "email_verified_at": emailVerifiedAt,
        "status": status,
        "meta": meta,
        "plan": plan,
        "plan_id": planId,
        "will_expire": willExpire,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "full_name": fullName,
    };
}
