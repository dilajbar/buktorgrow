import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../models/login_model.dart';
import '../../utils/api_list.dart';
import '../storages/user_secure_storage.dart';

class LoginService {
  Future<LoginModel?> login({
    required username,
    required password,
  }) async {
    final url = Uri.parse(ApiList.login!);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          LoginModel loginModel = loginModelFromJson(response.body);
          await UserSecureStorage.setToken(loginModel.userToken!);
          return loginModel;
        } else {
          log('Login failed with status: ${responseBody['status']}');
          return null;
        }
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

  Future<bool?> logout({
    required token,
  }) async {
    final url = Uri.parse(ApiList.logout!);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
        body: jsonEncode({'user_token': token}),
      );
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
}
