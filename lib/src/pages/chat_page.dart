import 'dart:convert';

import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final int chatId;
  const ChatPage({Key? key, required this.chatId}) : super(key: key);


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final User user = User(); 
  late WebSocketChannel channel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<dynamic, dynamic>> messageList = [];
  late String user_token = user.access ?? '';
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    user_token = user.access ?? '';
    channel = WebSocketChannel.connect(Uri.parse('ws://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/ws/socket-server/${widget.chatId}/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.chat),
            SizedBox(width: 5),
            Text(
              "Chat",
              style: TextStyle(color: Colors.blue),
            ),
            Text("Gepeteco")
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder:(context) =>[
              PopupMenuItem(
                child: Text("logout"),
                value: "/login",)
            ],
            onSelected:(value) {
              Navigator.of(context).pushReplacementNamed(value);
            },
          )
        ],
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
                  messageList.add(json);
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
          BottomAppBar(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView getMessageList() {
    List<Widget> listWidget = [];
    // {type: chat, message_data: {message: ts, user: 11, username: valdeir, timestamp: 2024-07-08 00:52:54}, user_token: }
    for (Map message_json in messageList) {
      if (message_json["message_data"]["user"] == user.id) {
        listWidget.add(MessageBubble(

            message:
                message_json["message_data"]["message"],
            isSentByMe: true));
      } else {
        listWidget.add(MessageBubble(
            username: message_json["message_data"]["username"],
            message: message_json["message_data"]["message"],
            isSentByMe: false));
      }
    }

    return ListView(
      controller: _scrollController,
      children: listWidget,
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    _scrollController.dispose();
    super.dispose();
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
        color: isSentByMe ? Colors.blue : Colors.grey[300],
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
                  color: isSentByMe ? Colors.white54 : Colors.black54,
                ),
                softWrap: true, // Permite quebra de linha
              ),
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? Colors.white : Colors.black,
              ),
              softWrap: true, // Permite quebra de linha
            ),
          ],
        ),
      ),
    );
  }
}
