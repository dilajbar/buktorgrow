import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../database/services/group_service.dart';
import '../models/group_list_model.dart';

class GroupListController extends GetxController {
  var totalGroups = 0.obs;

  static const _pageSize = 10;
  final PagingController<int, Group> pagingController =
      PagingController(firstPageKey: 1);

  GroupListController() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Fetch the group list with pagination
      final newItems =
          await GroupService().grouplist(pagekey: pageKey, rows: _pageSize);
      if (newItems != null && newItems.data != null) {
        totalGroups.value = newItems.meta?.total ?? 0;
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
}
