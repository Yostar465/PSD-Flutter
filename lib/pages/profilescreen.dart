import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkingslot/pages/bottom_nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Username";
  String email = "email@example.com";
  String password = "********";
  File? _profileImage;
  Uint8List? _webImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.56.1:21079/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed')),
        );
      }
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        setState(() {
          _webImage = result.files.first.bytes;
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Navigator.pushNamedAndRemoveUntil(context, '', (route) => false);
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.56.1:21079/edit_profile'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['username'] = username;

      if (kIsWeb) {
        if (_webImage != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'photo',
            _webImage!,
            filename: 'profile.jpg',
          ));
        }
      } else {
        if (_profileImage != null) {
          request.files.add(
              await http.MultipartFile.fromPath('photo', _profileImage!.path));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile update failed')),
        );
      }
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: kIsWeb
                    ? _webImage != null
                        ? MemoryImage(_webImage!)
                        : AssetImage('assets/profile_placeholder.png')
                            as ImageProvider
                    : _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
              ),
              TextButton(
                onPressed: _pickImage,
                child: const Text("PICK IMAGE"),
              ),
              TextButton(
                onPressed: _uploadProfileImage,
                child: const Text("UPLOAD"),
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: username,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: password,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/changeEmail');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                ),
                child: const Text("Change Email"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgotpassword');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: const Text("Change Password"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
    );
  }
}
