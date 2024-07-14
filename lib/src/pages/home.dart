import 'dart:ffi';

import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:chatgepeteco/src/pages/chat_page.dart';
import 'package:chatgepeteco/src/pages/models/repositorys/room_repository.dart';
import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:chatgepeteco/src/store/room_store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RoomState roomState;

  User anotherUserInstance = User();
  final List<Map<dynamic, dynamic>> roomList = [];

  @override
  void initState() {
    super.initState();
    roomState = RoomState(repository: RoomRepository());
    roomState.getRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.chat),
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
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("logout"),
                value: "/login",
              )
            ],
            onSelected: (value) {
              Navigator.of(context).pushReplacementNamed(value);
            },
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          roomState.isLoading,
          roomState.error,
          roomState.state,
        ]),
        builder: (context, child) {
          if (roomState.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color.fromARGB(255, 48, 32, 27),
            ));
          }
          if (roomState.state.value.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum item encontrado",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, child) => const SizedBox(
                height: 32,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: roomState.state.value.length,
              itemBuilder: (_, index) {
                final item = roomState.state.value[index];
                var title = item.nome ?? '';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                                room: item,
                              )),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "${item.id ?? ''}",
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddRoomDialog(context);
        },
      ),
    );
  }
}

Future<void> _showAddRoomDialog(BuildContext context) async {
  final TextEditingController _textController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adiconar Sala"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: "Nome da sala",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Criar'),
              onPressed: () {
                var url = Uri.parse(
                    "http://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/api/rooms/");
                http.post(url, body: {
                  'nome': _textController.text,
                });
                print(_textController);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/home");
              },
            )
          ],
        );
      });
}
