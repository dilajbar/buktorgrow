import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/api_list.dart';

class MessageSendService {
  Future<bool?> sendMessage({
    required message,
    required phone,
  }) async {
    final url = Uri.parse(ApiList.sendMessage!);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode({
          "phone": phone,
          "message": message,
        }),
      );
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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

  Future<bool?> sendMedia({
    required mediatype,
    required mediaurl,
    required phone,
    required filename,
  }) async {
    final url = Uri.parse(ApiList.sendMedia!);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode({
          "phone": phone,
          "media_type": mediatype,
          "media_url": mediaurl,
          "caption": "your caption for image or video media types",
          "file_name": filename
        }),
      );
      log("mediatype==$mediatype");
      log("mediaurl==$mediaurl");
      log(response.body);
      if (response.statusCode == 200) {
        return true;
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
