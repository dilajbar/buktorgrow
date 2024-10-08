import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/drawer_controller.dart';
import '../helpers/custome_color.dart';
import '../widgets/drawer_widget.dart';

class CallsListPage extends StatelessWidget {
  final Drawercontroller drawercontroller = Get.put(Drawercontroller());

  CallsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    drawercontroller.selectItem(2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Calls", style: GoogleFonts.aBeeZee()),
        centerTitle: true,
      ),
      drawer: CustomeDrawer(),
      body: Container(
        color: CustomColors().extraColor,
        child: Center(
          child: Text("No Calls", style: GoogleFonts.aBeeZee()),
        ),
      ),
    );
  }
}
