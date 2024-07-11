import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  
  final url = Uri.parse("https://70311e46-640e-4a89-b80c-c5a7c1183c2f-00-1o1djjno3rm5l.riker.replit.dev/api/token/");

   // Crie controladores de texto para cada TextField
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Icon(Icons.chat, size: 40,),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  
                  Container(
                    width: 5,
                  ),
                  Text("Chat", style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue
                  ),),
                  Text("Gepeteco", style: TextStyle(
                    fontSize: 30,
                  )),
                ],),
            ),
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:Column(
                children: [
                  TextField(controller: _username,cursorColor: Colors.blue,decoration: InputDecoration(label:Text("Username"),border: OutlineInputBorder())),
                  Container(
                    height: 5,
                  ),
                  TextField(controller: _password,obscureText: true,cursorColor: Colors.blue,decoration: InputDecoration(label:Text("Password"),border: OutlineInputBorder())
                  ),
                  Container(
                    height: 8,
                  ),
                  FilledButton(style:ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),child:Text("Cadastrar"), onPressed: () async {
                    if(_password.text.isNotEmpty && _username.text.isNotEmpty) {

                      var response = await http.post(url, body: {'username': '${_username.text}', 'password': '${_password.text}'});
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                      _username.text = '';
                      _password.text = '';
                    }

                  }),
                  Container(
                    height: 15,
                  ),
                  TextButton(child: Text("login", style: TextStyle(
                    color: Colors.grey
                  ),), onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/register");
                  })
                ],
              ) 
              ,
            )
           ],
        ),
      )
    );
  }
}