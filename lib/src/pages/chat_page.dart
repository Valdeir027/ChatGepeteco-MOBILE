import 'dart:convert';

import 'package:chatgepeteco/src/constants.dart';
import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:chatgepeteco/src/pages/models/roomModel.dart';
import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final Room room;
  const ChatPage({super.key, required this.room});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final User user = User();
  late WebSocketChannel channel;
  final TextEditingController _messageController = TextEditingController();
  final List<MessageBubble> messageList = [];
  late String user_token = user.access ?? '';
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    user_token = user.access ?? '';
    channel = WebSocketChannel.connect(Uri.parse(
        '${Constants.WSBASEURL}/ws/socket-server/${widget.room.id}/'));
    getMessages();
    super.initState();
  }
  @override
  void dispose() {
    channel.sink.close();
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.room.nome != null
            ? Text(widget.room.nome!)
            : const Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var json = jsonDecode(snapshot.data);
                  if (json["message_data"]["user"] == user.id) {
                    messageList.add(MessageBubble(
                        message: json["message_data"]["message"],
                        isSentByMe: true));
                  } else {
                    messageList.add(MessageBubble(
                        username: json["message_data"]["username"],
                        message: json["message_data"]["message"],
                        isSentByMe: false));
                  }
                  print(json);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  });
                }
                
                return getMessageList();
                
              },
            ),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 150),
            margin: EdgeInsets.only(bottom: 10, top:2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: TextField(
                      maxLines: null,
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                ),

                 ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 50),
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: IconButton(
                            // color: Colors.blue,
                            iconSize: 30,
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              // Lógica para enviar a mensagem aqui
                              String messageText = _messageController.text.trim();
                              if (messageText.isNotEmpty) {
                                var data = jsonEncode({
                                  "user_id": user.id,
                                  "message": messageText,
                                  "user_token": user_token
                                });
                          
                                channel.sink.add(data);
                          
                                // Enviar a mensagem para o servidor WebSocket
                                // channel.sink.add(messageText);
                                // Limpar o campo de texto
                                _messageController.clear();
                              }
                            },
                          ),
                      ),
                      ),
                
              ],
            ),
            
          ),
        ],
      ),
    );
  }

  ListView getMessageList() {

    List<Widget> listWidget = [];
    for ( MessageBubble message in messageList) {
      listWidget.add(message);
    }

    return ListView(
      controller: _scrollController,
      children: listWidget,
    );
  }
  Future<void> getMessages() async {
    var url = Uri.parse("http://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/api/messages/by_room/?room_id=${widget.room.id!}");
    var response = await http.get(url);
    var responseBody = utf8.decode(response.bodyBytes);
    var data = jsonDecode(responseBody);
    setState(() {
      for (Map message in data){
        if (message["user"] == user.id) {
          messageList.add(MessageBubble(
              message: message["mensagem"],
              isSentByMe: true));
        } else {
          messageList.add(MessageBubble(
              username: message["user_name"],
              message: message["mensagem"],
              isSentByMe: false));
        }
         WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent + 50,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  });
      }
    
    });
  }

  
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String? username;
  final bool isSentByMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSentByMe ? ThemeControl.instance.isDarkTheme?  Colors.blue[800]: Colors.blue : ThemeControl.instance.isDarkTheme?  const Color.fromARGB(255, 42, 45, 65):Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width *
            0.7, // Largura máxima como 70% da largura da tela
      ),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (username != null && username!.isNotEmpty)
              Text(
                username!,
                style: TextStyle(
                  color: ThemeControl.instance.isDarkTheme?  Colors.white54: Colors.black54,
                ),
                softWrap: true, // Permite quebra de linha
              ),
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? Colors.white : ThemeControl.instance.isDarkTheme?  Colors.white: Colors.black,
              ),
              softWrap: true, // Permite quebra de linha
            ),
          ],
        ),
      ),
    );
  }
}
