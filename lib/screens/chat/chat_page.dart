import 'package:flutter/material.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: const Center(
        child: Text("Chat Page Content"),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
