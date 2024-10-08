import 'dart:developer';
import 'dart:io';

import '../../models/group_list_model.dart';
import '../../utils/api_list.dart';
import 'package:http/http.dart' as http;

class GroupService {
  Future<GroupListModel?> grouplist({
    required int pagekey,
    required int rows,
  }) async {
    final url = Uri.parse("${ApiList.grouplist}?per_page=$rows&page=$pagekey");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Tokens.basilToken}',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        GroupListModel categoriesmodel = groupListModelFromJson(response.body);
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
}
