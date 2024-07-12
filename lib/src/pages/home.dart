

import 'package:chatgepeteco/src/pages/chat_page.dart';
import 'package:chatgepeteco/src/pages/models/repositorys/room_repository.dart';
import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:chatgepeteco/src/store/room_store.dart';
import 'package:flutter/material.dart';

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
      body: AnimatedBuilder(
        animation: Listenable.merge([
                roomState.isLoading,
                roomState.error,
                roomState.state,
            ]),
        builder: (context, child) {
          if (roomState.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 48, 32, 27),));
          }
          if (roomState.state.value.isNotEmpty) {
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
                      var title = item.nome ??'';
                      return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPage(chatId: item.id!,)),
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
                                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
    );
  }
}
