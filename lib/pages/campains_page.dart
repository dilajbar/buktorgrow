import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/drawer_controller.dart';
import '../helpers/custome_color.dart';
import '../widgets/drawer_widget.dart';

class CampainsPage extends StatelessWidget {
  final Drawercontroller drawercontroller = Get.put(Drawercontroller());

  CampainsPage({super.key});

  @override
  Widget build(BuildContext context) {
    drawercontroller.selectItem(4);
    return Scaffold(
      appBar: AppBar(
        title: Text("Campains", style: GoogleFonts.aBeeZee()),
        centerTitle: true,
      ),
      drawer: CustomeDrawer(),
      body: Container(
        color: CustomColors().extraColor,
        child: Center(
          child: Text("No Campains", style: GoogleFonts.aBeeZee()),
        ),
      ),
    );
  }
}
