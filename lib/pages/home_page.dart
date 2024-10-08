import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../controller/home_page_controller.dart';
import '../helpers/custome_color.dart';
import '../widgets/contacts_list_page.dart';
import '../widgets/drawer_widget.dart';
import '../models/all_chats_model.dart';
import 'new_chat_page.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Buktor Grow',
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
        backgroundColor: CustomColors().tertiaryColor,
        surfaceTintColor: CustomColors().tertiaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      drawer: CustomeDrawer(),
      body: RefreshIndicator(
        onRefresh: homeController.refresh,
        child: PagedListView<int, Datum>(
          pagingController: homeController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Datum>(
            itemBuilder: (context, item, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 16),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ChatPage(
                          contactId: item.uuid.toString(),
                          name: item.fullName,
                          avatar: item.avatar,
                          phone: item.phone,
                          latestChatCreatedAt: item.latestChatCreatedAt,
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            item.avatar != null
                                ? CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        item.avatar!),
                                  )
                                : CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey[400],
                                    child: const Icon(Icons.person),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.fullName ?? 'No Name',
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.formattedPhoneNumber ?? 'No Phone',
                                    style: GoogleFonts.aBeeZee(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  homeController
                                      .formatDate(item.latestChatCreatedAt),
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            firstPageProgressIndicatorBuilder: (_) => const Center(
                child: SizedBox(
                    height: 25, width: 25, child: CircularProgressIndicator())),
            newPageProgressIndicatorBuilder: (_) => const Center(
                child: SizedBox(
                    height: 25, width: 25, child: CircularProgressIndicator())),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ContactListPage());
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.chat_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
