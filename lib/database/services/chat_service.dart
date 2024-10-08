import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../models/all_chats_model.dart';
import '../../models/individual_chat_model.dart';
import '../../utils/api_list.dart';
import '../storages/user_secure_storage.dart';

class ChatService {
  Future<AllChatModel?> allchatlist({
    required int pagekey,
    required int rows,
  }) async {
    var bearerToken = await UserSecureStorage.getToken();
    final url = Uri.parse(ApiList.allchats!);
    Map<String, dynamic> body = {
      "page": pagekey,
      "per_page": rows,
      "organization_id": 1,
      "user_token": bearerToken
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        AllChatModel categoriesmodel = allChatModelFromJson(response.body);
        return categoriesmodel;
      } else {
        return null;
      }
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<IndividualChatModel?> individualchat({
    required String contactid,
    required int pagekey,
    required int rows,
  }) async {
    var bearerToken = await UserSecureStorage.getToken();
    final url = Uri.parse("${ApiList.individualchats}/$contactid");
    Map<String, dynamic> body = {
      "page": pagekey,
      "per_page": rows,
      "organization_id": 1,
      "user_token": bearerToken
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode(body),
      );
      // log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        IndividualChatModel individualChatModel =
            individualChatModelFromJson(response.body);
        return individualChatModel;
      } else {
        return null;
      }
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
