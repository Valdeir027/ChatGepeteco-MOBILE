import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.chat_bubble),
          Container(
            width: 5,
          ),
          Text("Chat", style: TextStyle(
            color: Colors.blue
          ),),
          Text("Gepeteco"),
        ],),
        actions: [
          IconButton(icon: Icon(Icons.menu_sharp),onPressed: (){
            Navigator.of(context).pushReplacementNamed("/chat");
          },)
        ],
      ),
      body: Container(
        child: Center(
              child: Text("HomePage"),
            ),
      ),
    );
  }
}