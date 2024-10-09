// To parse this JSON data, do
//
//     final individualChatModel = individualChatModelFromJson(jsonString);

import 'dart:convert';

IndividualChatModel individualChatModelFromJson(String str) =>
    IndividualChatModel.fromJson(json.decode(str));

String individualChatModelToJson(IndividualChatModel data) =>
    json.encode(data.toJson());

class IndividualChatModel {
  String? status;
  Data? data;

  IndividualChatModel({
    this.status,
    this.data,
  });

  factory IndividualChatModel.fromJson(Map<String, dynamic> json) =>
      IndividualChatModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Contact? contact;
  dynamic ticket;
  List<ChatThread>? chatThread;
  Pagination? pagination;

  Data({
    this.contact,
    this.ticket,
    this.chatThread,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
        ticket: json["ticket"],
        chatThread: json["chatThread"] == null
            ? []
            : List<ChatThread>.from(
                json["chatThread"]!.map((x) => ChatThread.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "contact": contact?.toJson(),
        "ticket": ticket,
        "chatThread": chatThread == null
            ? []
            : List<dynamic>.from(chatThread!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class ChatThread {
  String? type;
  LastChat? value;
  bool isLoading;

  ChatThread({
    this.type,
    this.value,
    this.isLoading = false
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) => ChatThread(
        type: json["type"],
        value: json["value"] == null ? null : LastChat.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value?.toJson(),
      };
}

class LastChat {
  int? id;
  String? uuid;
  int? organizationId;
  String? wamId;
  int? contactId;
  dynamic userId;
  String? type;
  Metadata? metadata; // Updated field type
  int? mediaId;
  String? status;
  int? isRead;
  dynamic deletedBy;
  dynamic deletedAt;
  DateTime? createdAt;
  Media? media;
  dynamic user;

  LastChat({
    this.id,
    this.uuid,
    this.organizationId,
    this.wamId,
    this.contactId,
    this.userId,
    this.type,
    this.metadata,
    this.mediaId,
    this.status,
    this.isRead,
    this.deletedBy,
    this.deletedAt,
    this.createdAt,
    this.media,
    this.user,
  });

  factory LastChat.fromJson(Map<String, dynamic> json) => LastChat(
        id: json["id"],
        uuid: json["uuid"],
        organizationId: json["organization_id"],
        wamId: json["wam_id"],
        contactId: json["contact_id"],
        userId: json["user_id"],
        type: json["type"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(jsonDecode(json["metadata"])),
        mediaId: json["media_id"],
        status: json["status"],
        isRead: json["is_read"],
        deletedBy: json["deleted_by"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        media: json["media"] == null ? null : Media.fromJson(json["media"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "organization_id": organizationId,
        "wam_id": wamId,
        "contact_id": contactId,
        "user_id": userId,
        "type": type,
        "metadata": metadata == null
            ? null
            : jsonEncode(metadata!.toJson()), // Convert to JSON string
        "media_id": mediaId,
        "status": status,
        "is_read": isRead,
        "deleted_by": deletedBy,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "media": media?.toJson(),
        "user": user,
      };
}

class Media {
  int? id;
  String? name;
  String? path;
  String? location;
  String? type;
  String? size;
  DateTime? createdAt;

  Media({
    this.id,
    this.name,
    this.path,
    this.location,
    this.type,
    this.size,
    this.createdAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        name: json["name"],
        path: json["path"],
        location: json["location"],
        type: json["type"],
        size: json["size"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "path": path,
        "location": location,
        "type": type,
        "size": size,
        "created_at": createdAt?.toIso8601String(),
      };
}

class Contact {
  int? id;
  String? uuid;
  int? organizationId;
  String? firstName;
  String? lastName;
  String? phone;
  dynamic email;
  DateTime? latestChatCreatedAt;
  dynamic avatar;
  String? address;
  dynamic metadata;
  int? contactGroupId;
  int? isFavorite;
  int? aiAssistanceEnabled;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? fullName;
  String? formattedPhoneNumber;
  LastChat? lastChat;
  LastChat? lastInboundChat;
  List<dynamic>? notes;

  Contact({
    this.id,
    this.uuid,
    this.organizationId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.latestChatCreatedAt,
    this.avatar,
    this.address,
    this.metadata,
    this.contactGroupId,
    this.isFavorite,
    this.aiAssistanceEnabled,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fullName,
    this.formattedPhoneNumber,
    this.lastChat,
    this.lastInboundChat,
    this.notes,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        uuid: json["uuid"],
        organizationId: json["organization_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        latestChatCreatedAt: json["latest_chat_created_at"] == null
            ? null
            : DateTime.parse(json["latest_chat_created_at"]),
        avatar: json["avatar"],
        address: json["address"],
        metadata: json["metadata"],
        contactGroupId: json["contact_group_id"],
        isFavorite: json["is_favorite"],
        aiAssistanceEnabled: json["ai_assistance_enabled"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        fullName: json["full_name"],
        formattedPhoneNumber: json["formatted_phone_number"],
        lastChat: json["last_chat"] == null
            ? null
            : LastChat.fromJson(json["last_chat"]),
        lastInboundChat: json["last_inbound_chat"] == null
            ? null
            : LastChat.fromJson(json["last_inbound_chat"]),
        notes: json["notes"] == null
            ? []
            : List<dynamic>.from(json["notes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "organization_id": organizationId,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "latest_chat_created_at": latestChatCreatedAt?.toIso8601String(),
        "avatar": avatar,
        "address": address,
        "metadata": metadata,
        "contact_group_id": contactGroupId,
        "is_favorite": isFavorite,
        "ai_assistance_enabled": aiAssistanceEnabled,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "full_name": fullName,
        "formatted_phone_number": formattedPhoneNumber,
        "last_chat": lastChat?.toJson(),
        "last_inbound_chat": lastInboundChat?.toJson(),
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
      };
}

class Pagination {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Pagination({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int? id;
  int? contactId;
  String? entityType;
  int? entityId;
  dynamic deletedBy;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.contactId,
    this.entityType,
    this.entityId,
    this.deletedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        contactId: json["contact_id"],
        entityType: json["entity_type"],
        entityId: json["entity_id"],
        deletedBy: json["deleted_by"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_id": contactId,
        "entity_type": entityType,
        "entity_id": entityId,
        "deleted_by": deletedBy,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Metadata {
  String? id;
  String? type;
  ImageMetadata? image;
  String? from;
  String? timestamp;
  TextMetadata? text;
  InteractiveMetadata? interactive;
  ContextMetadata? context;

  Metadata({
    this.id,
    this.type,
    this.image,
    this.from,
    this.timestamp,
    this.text,
    this.interactive,
    this.context,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        id: json["id"],
        type: json["type"],
        image: json["image"] == null
            ? null
            : ImageMetadata.fromJson(json["image"]),
        from: json["from"],
        timestamp: json["timestamp"],
        text: json["text"] == null ? null : TextMetadata.fromJson(json["text"]),
        interactive: json["interactive"] == null
            ? null
            : InteractiveMetadata.fromJson(json["interactive"]),
        context: json["context"] == null
            ? null
            : ContextMetadata.fromJson(json["context"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "image": image?.toJson(),
        "from": from,
        "timestamp": timestamp,
        "text": text?.toJson(),
        "interactive": interactive?.toJson(),
        "context": context?.toJson(),
      };
}

class ImageMetadata {
  String? mimeType;
  String? sha256;
  String? id;

  ImageMetadata({
    this.mimeType,
    this.sha256,
    this.id,
  });

  factory ImageMetadata.fromJson(Map<String, dynamic> json) => ImageMetadata(
        mimeType: json["mime_type"],
        sha256: json["sha256"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "mime_type": mimeType,
        "sha256": sha256,
        "id": id,
      };
}

class TextMetadata {
  String? body;

  TextMetadata({
    this.body,
  });

  factory TextMetadata.fromJson(Map<String, dynamic> json) => TextMetadata(
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "body": body,
      };
}

class InteractiveMetadata {
  String? type;
  NfmReply? nfmReply;
  ButtonReply? buttonReply;

  InteractiveMetadata({
    this.type,
    this.nfmReply,
    this.buttonReply,
  });

  factory InteractiveMetadata.fromJson(Map<String, dynamic> json) =>
      InteractiveMetadata(
        type: json["type"],
        nfmReply: json["nfm_reply"] == null
            ? null
            : NfmReply.fromJson(json["nfm_reply"]),
        buttonReply: json["button_reply"] == null
            ? null
            : ButtonReply.fromJson(json["button_reply"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "nfm_reply": nfmReply?.toJson(),
        "button_reply": buttonReply?.toJson(),
      };
}

class NfmReply {
  String? responseJson;
  String? body;
  String? name;

  NfmReply({
    this.responseJson,
    this.body,
    this.name,
  });

  factory NfmReply.fromJson(Map<String, dynamic> json) => NfmReply(
        responseJson: json["response_json"],
        body: json["body"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "response_json": responseJson,
        "body": body,
        "name": name,
      };
}

class ButtonReply {
  String? id;
  String? title;

  ButtonReply({
    this.id,
    this.title,
  });

  factory ButtonReply.fromJson(Map<String, dynamic> json) => ButtonReply(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class ContextMetadata {
  String? from;
  String? id;

  ContextMetadata({
    this.from,
    this.id,
  });

  factory ContextMetadata.fromJson(Map<String, dynamic> json) =>
      ContextMetadata(
        from: json["from"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "id": id,
      };
}
