import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Message Screen'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'This is the message screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}