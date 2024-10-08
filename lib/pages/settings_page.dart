import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/drawer_controller.dart';
import '../helpers/custome_color.dart';
import '../widgets/drawer_widget.dart';

class BusinessProfilePage extends StatelessWidget {
  final Drawercontroller drawercontroller = Get.put(Drawercontroller());

  BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    drawercontroller.selectItem(5);
    return Scaffold(
      appBar: AppBar(
        title: Text("Business Profile", style: GoogleFonts.aBeeZee()),
        centerTitle: true,
      ),
      drawer: CustomeDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Container(
            color: CustomColors().extraColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  "Dr. Basil's Homeo Hospital",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextFormField('Phone', '+91 94462 23574'),
                _buildTextFormField('Address',
                    'Opposite Bus Stand, Near Supplyco Super Market, Manjeri Road, Pandikkad, Malappurm District'),
                _buildTextFormField('Email', 'Info@drbasilhomeo.com'),
                _buildTextFormField('Business Description',
                    "🌿 Dr. Basil's Homeo Hospital 🌿\n✨ Biggest Homoeopathic Hospital with 50+ Doctors Serving in 25+ Countries\n✨ Trusted Homeopathic Care\n✨ Personalized Treatment Plans\n✨ Compassionate and Professional Staff\n✨ Holistic Health Solutions"),
                _buildTextFormField('Industry', 'Medical and health'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: true,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.aBeeZee(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        style: GoogleFonts.aBeeZee(fontSize: 14),
      ),
    );
  }
}
