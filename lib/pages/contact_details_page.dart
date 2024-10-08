import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contacts_list_controller.dart';
import '../models/contactlist_model.dart';
import '../widgets/contacts_list_page.dart';

class ContactDetailsPage extends StatelessWidget {
  final ContactListcontroller contactListcontroller =
      Get.put(ContactListcontroller());
  final Datum contact;

  ContactDetailsPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: contact.avatar != null
                      ? NetworkImage(contact.avatar!)
                      : null,
                  child: contact.avatar == null
                      ? Text(
                          contact.fullName?.substring(0, 1).toUpperCase() ??
                              '?',
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  contact.fullName ?? 'No Name',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              ContactDetailItem(
                  icon: Icons.phone,
                  title: 'Phone',
                  value: contact.phone ?? 'No Phone Number'),
              ContactDetailItem(
                  icon: Icons.email,
                  title: 'Email',
                  value: contact.email ?? 'No Email'),
              ContactDetailItem(
                  icon: Icons.location_on,
                  title: 'Address',
                  value: contact.address ?? 'Not available'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                      icon: Icons.call,
                      label: 'Call',
                      onPressed: () {
                        contactListcontroller
                            .makePhoneCall(contact.phone.toString());
                      }),
                  ActionButton(
                      icon: Icons.message,
                      label: 'Message',
                      onPressed: () {
                        contactListcontroller.makeSMS(contact.phone.toString());
                      }),
                  ActionButton(
                      icon: Icons.videocam,
                      label: 'Video',
                      onPressed: () {
                        contactListcontroller
                            .connectWhatsApp(contact.phone.toString());
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
