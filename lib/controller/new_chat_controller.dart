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

 final PagingController<int, ChatThread> pagingController =
      PagingController(firstPageKey: 1);
  final chatData = Rx<Data>(Data());
  final RxList<ChatThread> newMessages = <ChatThread>[].obs;
  final int _pageSize = 20;
  late final String contactId;

  NewChatController(this.contactId) {
    pagingController.addPageRequestListener((pageKey) {
      fetchChatData(pageKey);
    });
  }

  Future<void> fetchChatData(int pageKey) async {
    try {
      final response = await ChatService().individualchat(
        contactid: contactId,
        pagekey: pageKey,
        rows: _pageSize,
      );

      if (response != null && response.data != null) {
        final fetchedMessages = response.data!.chatThread ?? [];
        final isLastPage = fetchedMessages.length < _pageSize;

        // Append data to PagingController
        if (isLastPage) {
          pagingController.appendLastPage(fetchedMessages);
        } else {
          final nextPageKey = pageKey + _pageSize;
          pagingController.appendPage(fetchedMessages, nextPageKey);
        }

        // Update the reactive newMessages list
        if (pageKey == 1) {
          newMessages.assignAll(fetchedMessages); // Replace with new data
        } else {
          newMessages.addAll(fetchedMessages); // Append new data
        }

        // Update chatData
        chatData.value = response.data!;
      } else {
        pagingController.appendLastPage([]); // Handle empty or last page
      }
    } catch (error) {
      pagingController.error = error; // Handle error in PagingController
      log('Error fetching chat data: $error');
    }
  }

  // Method to insert a local message and instantly update the UI
  void insertLocalMessage(ChatThread message) {
    newMessages.insert(0, message); // Insert at the top of the list
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
