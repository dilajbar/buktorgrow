import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import '../database/services/chat_service.dart';
import '../models/all_chats_model.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var totalChats = 0.obs;

  void selectPage(int index) {
    selectedIndex.value = index;
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    try {
      if (inputDate == today) {
        // If the date is today, return time only in 12-hour format
        return DateFormat('h:mm a').format(dateTime);
      } else if (inputDate == yesterday) {
        // If the date is yesterday, return "Yesterday"
        return 'Yesterday';
      } else {
        // For dates older than yesterday, return in 'd/M/yy' format
        // Note the change from 'M/d/yy' to 'd/M/yy' to match your requirement
        String formattedDate = DateFormat('d/M/yy').format(dateTime);

        // Add a check to ensure the formatted date is valid
        if (formattedDate.contains('33')) {
          print(
              'Error: Invalid date format detected. Raw date: $dateTime, Formatted: $formattedDate');
          // Fallback to a different format if an invalid date is detected
          return DateFormat('dd MMM yyyy').format(dateTime);
        }

        return formattedDate;
      }
    } catch (e) {
      print('Error formatting date: $e. Raw date: $dateTime');
      // Return a fallback format in case of any error
      return dateTime.toString();
    }
  }

  static const _pageSize = 10;
  final PagingController<int, Datum> pagingController =
      PagingController(firstPageKey: 0);

  HomeController() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final AllChatModel? chatModel = await ChatService().allchatlist(
        pagekey: pageKey,
        rows: _pageSize,
      );
      if (chatModel != null && chatModel.data != null) {
        final List<Datum> newItems = chatModel.data!.data ?? [];
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + newItems.length;
          pagingController.appendPage(newItems, nextPageKey);
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
}
