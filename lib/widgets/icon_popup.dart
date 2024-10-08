import 'package:buktorgrow/controller/textbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconPopup extends StatefulWidget {
  const IconPopup({super.key, this.phone});
  final String? phone;

  @override
  State<IconPopup> createState() => _IconPopupState();
}

class _IconPopupState extends State<IconPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<TextBarController>().onClear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextBarController controller = Get.put(TextBarController());

    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Card(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconCreation(Icons.insert_drive_file_outlined,
                          Colors.indigo, 'Document', () {
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(
                          Icons.camera_alt_outlined, Colors.pink, 'Camera', () {
                        controller.openDocumentPicker(widget.phone);
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(
                          Icons.insert_photo_outlined, Colors.purple, 'Gallery',
                          () {
                        controller.openGallery(widget.phone);
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconCreation(
                          Icons.headset_outlined, Colors.orange, 'Audio', () {
                        controller.openAudioPicker(widget.phone);
                        Navigator.pop(context);
                      }),
                      const SizedBox(
                        width: 30,
                      ),
                      iconCreation(Icons.person_outlined, Colors.blue,
                          'Contacts', () {}),
                      const SizedBox(
                        width: 30,
                      ),
                      // iconCreation(Icons.location_pin, Colors.green, 'Location',
                      //     () {
                      //   controller.shareLocation(widget.phone);
                      //   Navigator.pop(context);
                      // }),
                      iconCreation(Icons.videocam, Colors.red, 'video', () {
                        controller.openVideoRecorder(widget.phone);
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget iconCreation(IconData icon, Color color, String text, Function ontap) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          ontap();
        },
        child: CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Icon(
            color: Colors.white,
            icon,
            size: 29,
          ),
        ),
      ),
      Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      )
    ],
  );
}
