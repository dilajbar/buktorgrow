import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/services/contact_service.dart';
import '../models/contactlist_model.dart';

class ContactListcontroller extends GetxController {
  var totalContacts = 0.obs;
  static const _pageSize = 10;
  final PagingController<int, Datum> pagingController =
      PagingController(firstPageKey: 1);

  ContactListcontroller() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ContactService().contactlist(
        pagekey: pageKey,
        rows: _pageSize,
      );
      if (newItems != null && newItems.data != null) {
        totalContacts.value = newItems.meta?.total ?? 0;
        final isLastPage = newItems.data!.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems.data!);
        } else {
          final nextPageKey = pageKey + newItems.data!.length;
          pagingController.appendPage(newItems.data!, nextPageKey);
        }
      } else {
        pagingController.appendLastPage([]);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  @override
  Future<void> refresh() async {
    pagingController.refresh();
  }

  void makePhoneCall(String phoneNumber) async {
    if (phoneNumber != '' && phoneNumber.isNotEmpty) {
      final String url = 'tel:$phoneNumber';
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Fluttertoast.showToast(
          msg: "Could not launch $url",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        log('Could not launch $url');
      }
    } else {
      Fluttertoast.showToast(msg: "Phone number is null or empty");

      log('Phone number is null or empty');
    }
  }

  void makeVideoCall(String videoCallUrl) async {
    if (videoCallUrl != '' && videoCallUrl.isNotEmpty) {
      final Uri uri = Uri.parse(videoCallUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Fluttertoast.showToast(
          msg: "Could not launch $videoCallUrl",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        log('Could not launch $videoCallUrl');
      }
    } else {
      Fluttertoast.showToast(msg: "Video call URL is null or empty");
      log('Video call URL is null or empty');
    }
  }

  void makeSMS(String phoneNumber) async {
    if (phoneNumber != '' && phoneNumber.isNotEmpty) {
      final String smsUrl = 'sms:$phoneNumber';
      final Uri uri = Uri.parse(smsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Fluttertoast.showToast(msg: "Could not launch $smsUrl");
        log('Could not launch $smsUrl');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Phone number is null or empty",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      log('Phone number is null or empty');
    }
  }

  void connectWhatsApp(String phoneNumber) async {
    if (phoneNumber != "" && phoneNumber.isNotEmpty) {
      final String whatsappUrl = "https://wa.me/$phoneNumber";
      final Uri uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Fluttertoast.showToast(
          msg: "Could not launch $phoneNumber",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        log('Could not launch $phoneNumber');
      }
    } else {
      Fluttertoast.showToast(msg: "Phone number is null or empty");
      log('Phone number is null or empty');
    }
  }
}
