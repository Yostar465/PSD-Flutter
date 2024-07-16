import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parkingslot/api/service.dart';
import 'dart:convert';
import 'package:parkingslot/pages/bottom_nav_bar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String statusMessage = "Press the button to start detection";
  int freeSlots = 0;

  void startDetection() async {
    final response = await http
        .get(Uri.parse(AppServices.getDetectEndpoint()));

    if (response.statusCode == 200) {
      setState(() {
        statusMessage = "Video recording and object detection started";
      });
    } else {
      setState(() {
        statusMessage = "Failed to start detection";
      });
    }
  }

  void fetchFreeSlots() async {
    final response = await http
        .get(Uri.parse(AppServices.getFreeSlotEndpoint()));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        freeSlots = data['free_slots'];
      });
    } else {
      setState(() {
        freeSlots = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFreeSlots(); // Fetch the initial free slots count when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text("Detect"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'assets/camera.png'), // Placeholder for the image
            const SizedBox(height: 20),
            Text(
              statusMessage,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Free Slots: $freeSlots',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startDetection,
              child:
                  const Icon(Icons.camera_alt, size: 30), // Smaller camera icon
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}
