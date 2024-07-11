import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final channel = WebSocketChannel.connect(Uri.parse('wss://70311e46-640e-4a89-b80c-c5a7c1183c2f-00-1o1djjno3rm5l.riker.replit.dev/ws/socket-server/15/'));
  TextEditingController _messageController = TextEditingController();
  final List<Map<dynamic, dynamic>> messageList = [];
  final String user_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwNDYyNzA0LCJpYXQiOjE3MjA0NjI0MDQsImp0aSI6IjFmNDU5YmIyOGJlZDRlYTk4ZTQzNTc4MjUxOTk3MGYxIiwidXNlcl9pZCI6MX0.LlMiPN3YcTeJMNxKxFHSRXkm2JuSWycK7PJ4b3o4AIo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
          IconButton(
            icon: Icon(Icons.menu_sharp),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/home");
            },
          ),
          
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var json = jsonDecode(snapshot.data);
                  messageList.add(json);
                  print(json);
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
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Lógica para enviar a mensagem aqui
                    String messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      var data  = jsonEncode({
                      "user_id":1,
                      "message":messageText,
                      "user_token":user_token
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
ListView getMessageList(){
  List<Widget> listWidget = [];
// {type: chat, message_data: {message: ts, user: 11, username: valdeir, timestamp: 2024-07-08 00:52:54}, user_token: }
  for (Map message_json in messageList){
      if (message_json["message_data"]["user"] == 1){
        listWidget.add(MessageBubble(message:message_json["message_data"]["message"], isSentByMe: true));
      }else{
        listWidget.add(MessageBubble(message:message_json["message_data"]["message"], isSentByMe: false));
      }
  }

  return ListView(children:listWidget);
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;


  const MessageBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSentByMe ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7, // Largura máxima como 70% da largura da tela
      ),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
          ),
          softWrap: true, // Permite quebra de linha
        ),
      ),
    );
  }
  
}



