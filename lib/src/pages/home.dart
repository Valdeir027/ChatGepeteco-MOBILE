import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User anotherUserInstance = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.chat_bubble),
            Container(
              width: 5,
            ),
            const Text(
              "Chat",
              style: TextStyle(color: Colors.blue),
            ),
            const Text("Gepeteco"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_sharp),
            onPressed: () {
              print("Clicou no menu");
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text(anotherUserInstance.username ?? 'No user data'),
        ),
      ),
    );
  }
}
