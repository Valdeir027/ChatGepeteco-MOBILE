
import 'package:chatgepeteco/src/constants.dart';
import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:chatgepeteco/src/pages/chat_page.dart';
import 'package:chatgepeteco/src/pages/models/repositorys/room_repository.dart';
import 'package:chatgepeteco/src/pages/models/roomModel.dart';
import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:chatgepeteco/src/store/room_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Future<void> _refreshRoom() async{
      roomState.state.value.clear();
      roomState.getRoom();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: GestureDetector(
          onTap: (){
            setState(() {
              _refreshRoom();
            });
          },
          child: Row(
            children: [
              SvgPicture.string(
                Constants.svgIconChatString,
                colorFilter: ThemeControl.instance.isDarkTheme? const ColorFilter.mode(Colors.white70, BlendMode.srcIn) :const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                width: 30,
                height: 30,
              ),
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
        ),
        actions: [
          PopupMenuButton(
            
            popUpAnimationStyle:AnimationStyle(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500)
            ),
            itemBuilder: (context) => [
              if(ThemeControl.instance.isDarkTheme)
                const PopupMenuItem(
                  value: 1,
                  child: Row(

                      children: [
                      Expanded(child: Text("Modo claro ")),
                      Icon(Icons.light_mode),
                    ],),
                ),
              if(ThemeControl.instance.isDarkTheme == false)
                const PopupMenuItem(
                    value: 1,
                    child: Row(

                        children: [
                        Expanded(child: Text("Modo escuro ")),
                        Icon(Icons.dark_mode),
                      ],),
                  ),
              
              const PopupMenuItem(
                value: "/login",
                child: Row(
                  children: [
                    Expanded(child: Text("Logout")),
                    Icon(Icons.exit_to_app),
                  ],
                ),
              )
            ],
            onSelected: (value) {
              if (value is String) {

                Navigator.of(context).pushReplacementNamed(value);
              }
              if(value is int){
                switch (value) {
                  case 1:
                   setState(() {
                    ThemeControl.instance.changeTheme();    
                   });
                }
              }
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
            return RefreshIndicator(
              onRefresh: _refreshRoom,
              child: ListView.separated(
                separatorBuilder: (context, child) => const SizedBox(
                  height: 32,
                ),
                padding: const EdgeInsets.only(
                  bottom: 80,
                  left: 16,
                  right: 16,
              
                ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: [
                                 Expanded(
                                   child: Text(
                                      title,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 16.0, fontWeight: FontWeight.bold),
                                    ),
                                 ),
                                 IconButton(icon: const Icon(Icons.edit), onPressed: (){
                                  _showUpdateRoomDialog(context, item, roomState);
                                 },)
                              ],
                            ),
                            const SizedBox(height: 8.0), 
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(icon: const Icon(Icons.delete),
                              onPressed: () {
                                  _showDeleteRoomDialog(context, item, roomState);
                              }
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddRoomDialog(context, roomState);
        },
      ),
    );
  }
}

Future<void> _showDeleteRoomDialog(BuildContext context, Room room,  RoomState state) async {
  
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Deletando Sala"),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Text("Você tem certeza que quer deletar esta sala?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar', style: TextStyle(
                color: Colors.red
              ),),
              onPressed: () async {
                var url = Uri.parse(
                    "${Constants.BASEURL}/api/rooms/${room.id}/");

                var response = await http.delete(url);
                print(response.statusCode);
                if (response.statusCode ==204){
                Navigator.of(context).pop();
                  state.state.value.clear();
                  state.getRoom();
                }else {
                  print(response);
                }
              },
            )
          ],
        );
      });
}

Future<void> _showAddRoomDialog(BuildContext context, RoomState state) async {
  final TextEditingController textController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adiconar Sala"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "Nome da sala",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Criar'),
              onPressed: () async {
                var url = Uri.parse(
                    "${Constants.BASEURL}/api/rooms/");
                var response = await http.post(url, body: {
                  'nome': textController.text,
                });
                print(response.statusCode);
                if (response.statusCode ==201) {
                  Navigator.of(context).pop();
                  state.state.value.clear();
                  state.getRoom();

                }
              },
            )
          ],
        );
      });
}

Future<void> _showUpdateRoomDialog(BuildContext context, Room room, RoomState state) async {
  final TextEditingController textController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar da Sala"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "nome da sala",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Editar'),
              onPressed: () async {
                var url = Uri.parse(
                    "${Constants.BASEURL}/api/rooms/${room.id}/");
                var response = await http.patch(url, body: {
                  'nome': textController.text,
                });
                print(response.statusCode);
                if (response.statusCode ==200) {
                  Navigator.of(context).pop();
                  state.state.value.clear();
                  state.getRoom();
                }
              },
            )
          ],
        );
      });
}
