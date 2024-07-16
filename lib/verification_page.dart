import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _verificationCodeController =
      TextEditingController();

  Future<void> _verifyCode() async {
    final String code = _verificationCodeController.text;

    // Add your verification logic here
    // Example: Send the code to your server for verification

    // Mock response for demonstration
    bool isVerified = true; // Replace with actual server response

    if (isVerified) {
      print('Verification successful');
      // Navigate to the next page or show a success message
    } else {
      print('Verification failed');
      // Show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B3B98),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/parking.png', // Make sure to add your image in the assets folder and update the path
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'PARKING SLOT DETECTION',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  hintText: 'Verification Code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
