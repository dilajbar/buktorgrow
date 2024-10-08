import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../controller/contacts_list_controller.dart';
import '../controller/drawer_controller.dart';
import '../controller/group_list_controller.dart';
import '../helpers/custome_color.dart';
import '../models/contactlist_model.dart';
import '../models/group_list_model.dart';
import '../pages/new_chat_page.dart';
import 'drawer_widget.dart';

class ContactListPage extends StatelessWidget {
  final Drawercontroller drawercontroller = Get.put(Drawercontroller());
  final ContactListcontroller contactListcontroller =
      Get.put(ContactListcontroller());
  final GroupListController groupListController =
      Get.put(GroupListController());
  ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    drawercontroller.selectItem(3);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contacts"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Implement add contact functionality
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Contacts'),
              Tab(icon: Icon(Icons.group), text: 'Groups'),
            ],
          ),
          // toolbarHeight: 30.0,
        ),
        drawer: CustomeDrawer(),
        body: TabBarView(
          children: [
            _buildContactsTab(), // Content for Contacts tab
            _buildGroupsTab(), // Content for Groups tab
          ],
        ),
      ),
    );
  }

  Widget _buildContactsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Row(
            children: [
              Obx(
                () => Text(
                  '${contactListcontroller.totalContacts.value}',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                ' CONTACTS',
                style: GoogleFonts.aBeeZee(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: contactListcontroller.refresh,
            child: Container(
              color: CustomColors().extraColor,
              child: PagedListView<int, Datum>(
                pagingController: contactListcontroller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Datum>(
                  itemBuilder: (context, item, index) =>
                      ContactListItem(item: item),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text('Error loading contacts'),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text('No Contacts'),
                  ),
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator())),
                  newPageProgressIndicatorBuilder: (context) => const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator())),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Row(
            children: [
              Obx(
                () => Text(
                  '${groupListController.totalGroups.value}',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                ' Groups',
                style: GoogleFonts.aBeeZee(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: groupListController.refresh,
            child: Container(
              color: CustomColors().extraColor,
              child: PagedListView<int, Group>(
                pagingController: groupListController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Group>(
                  itemBuilder: (context, item, index) =>
                      GroupListItem(item: item),
                  firstPageErrorIndicatorBuilder: (context) => const Center(
                    child: Text('Error loading contacts'),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text('No Groups'),
                  ),
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator())),
                  newPageProgressIndicatorBuilder: (context) => const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator())),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContactListItem extends StatelessWidget {
  final Datum item;
  final ContactListcontroller contactListcontroller =
      Get.put(ContactListcontroller());

  ContactListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green[300],
                backgroundImage:
                    item.avatar != null ? NetworkImage(item.avatar!) : null,
                child: item.avatar == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fullName ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(item.phone ?? 'No Phone Number'),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_outlined),
                    onPressed: () {
                      Get.to(() => ChatPage(
                            contactId: item.uuid.toString(),
                            name: item.fullName,
                            avatar: item.avatar,
                            phone: item.phone,
                            latestChatCreatedAt: item.latestChatCreatedAt,
                          ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_outlined),
                    onPressed: () {
                      contactListcontroller
                          .makePhoneCall(item.phone.toString());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupListItem extends StatelessWidget {
  final Group item;
  final ContactListcontroller contactListcontroller =
      Get.put(ContactListcontroller());

  GroupListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green[300],
        child: const Icon(
          Icons.group,
          color: Colors.white,
        ),
        // child: Text(
        //   item.name?.substring(0, 1).toUpperCase() ?? '?',
        //   style: const TextStyle(fontWeight: FontWeight.bold),
        // )
      ),
      title: Text(
        item.name ?? 'No Name',
        style: const TextStyle(),
      ),
      onTap: () {
        // Implement contact details view
      },
    );
  }
}

class ContactDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactDetailItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.green,
        onPressed: onPressed,
      ),
    );
  }
}
