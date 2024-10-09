import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/services/chat_service.dart';
import '../models/individual_chat_model.dart';

class NewChatController extends GetxController {
  RxString lastScene = ''.obs; // Fixed naming convention
  static const _pageSize = 10;

  final PagingController<int, ChatThread> pagingController =
      PagingController(firstPageKey: 1);
  final chatData = Rx<Data>(Data());
  late final String contactId;

  NewChatController(this.contactId) {
    pagingController.addPageRequestListener((pageKey) {
      fetchChatData(pageKey);
    });
  }

  RxList<ChatThread> newMessages = <ChatThread>[].obs;

  Future<void> fetchChatData(int pageKey) async {
    try {
      final response = await ChatService().individualchat(
        contactid: contactId,
        pagekey: pageKey,
        rows: _pageSize,
      );

      if (response != null && response.data != null) {
         newMessages.value = response.data!.chatThread ?? [];
        final isLastPage = newMessages.length < _pageSize;

        if (isLastPage) {
          pagingController.appendLastPage(newMessages);
        } else {
          final nextPageKey = pageKey + _pageSize;
          pagingController.appendPage(newMessages, nextPageKey);
        }

        // Update chatData
        chatData.value = response.data!;
      } else {
        pagingController.appendLastPage([]);
      }
    } catch (error) {
      pagingController.error = error; // Handle error
      log('Error fetching chat data: $error'); // Logging error
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12; // Fix for midnight
    return lastScene.value = "$formattedHour:$minute $period";
  }

  void makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      final String url = 'tel:$phoneNumber';
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showToast("Could not launch $url");
      }
    } else {
      _showToast("Phone number is null or empty");
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
    log(message);
  }

  @override
  void onClose() {
    pagingController.dispose();

    super.onClose();
  }
}
