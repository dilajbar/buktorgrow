import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/drawer_controller.dart';
import '../controller/login_controller.dart';
import '../helpers/custome_color.dart';

class CustomeDrawer extends StatelessWidget {
  final Drawercontroller drawercontroller = Get.put(Drawercontroller());
  final LoginController loginController = Get.put(LoginController());

  CustomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: CustomColors().tertiaryColor,
        child: Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: ListTileTheme.of(context).copyWith(
              minVerticalPadding: 0,
              dense: true,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CustomColors().primaryColor,
                        CustomColors().extraColor2,
                      ],
                    ),
                  ),
                  child: Center(
                      child: Image.asset(
                    "assets/images/growth.png",
                    height: 40,
                    width: 40,
                  )),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildListTile('Log Out', HugeIcons.strokeRoundedLogout02,
                        6, () => loginController.logOut(),
                        isLogout: true),
                    ListTile(
                      title: Text(
                        'Version 1.0',
                        style: GoogleFonts.aBeeZee(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded(
              //   child: Obx(
              //     () => ListView(
              //       shrinkWrap: true,
              //       padding: EdgeInsets.zero,
              //       children: [
              //         _buildListTile('Chats', HugeIcons.strokeRoundedBubbleChat,
              //             1, () => Get.offAll(() => HomePage())),
              //         // _buildListTile('Calls', HugeIcons.strokeRoundedCall02, 2,
              //         //     () => Get.offAll(() => CallsListPage())),
              //         _buildListTile(
              //             'Contacts',
              //             HugeIcons.strokeRoundedContact01,
              //             3,
              //             () => Get.offAll(() => ContactListPage())),
              //         // _buildListTile(
              //         //     'Campaigns',
              //         //     HugeIcons.strokeRoundedMegaphone02,
              //         //     4,
              //         //     () => Get.offAll(() => CampainsPage())),
              //         // _buildListTile(
              //         //     'Settings',
              //         //     HugeIcons.strokeRoundedSettings01,
              //         //     5,
              //         //     () => Get.offAll(() => BusinessProfilePage())),
              //         _buildListTile('Log Out', HugeIcons.strokeRoundedLogout02,
              //             6, () => loginController.logOut(),
              //             isLogout: true),
              //         ListTile(
              //           title: Text(
              //             'Version 1.0',
              //             style: GoogleFonts.aBeeZee(
              //                 color: Colors.grey.shade500, fontSize: 13),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      String title, IconData icon, int index, VoidCallback onTap,
      {bool isLogout = false}) {
    return ListTile(
      leading: HugeIcon(
        icon: icon,
        color: Colors.blueGrey.shade700,
      ),
      title: Text(
        title,
        style:
            GoogleFonts.aBeeZee(color: Colors.blueGrey.shade700, fontSize: 16),
      ),
      selected: !isLogout && drawercontroller.selectedIndex.value == index,
      selectedTileColor: Colors.green.withOpacity(0.3),
      onTap: () {
        if (!isLogout) drawercontroller.selectItem(index);
        onTap();
      },
    );
  }
}
