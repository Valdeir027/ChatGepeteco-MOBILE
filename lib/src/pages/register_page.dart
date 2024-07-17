import 'dart:convert';

import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final url = Uri.parse(
      "http://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/api/register/");

  // Crie controladores de texto para cada TextField
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String json = "pra eu ver";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat,
              size: 40,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 5,
                  ),
                  const Text(
                    "Chat",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                  const Text("Gepeteco",
                      style: TextStyle(
                        fontSize: 30,
                      )),
                ],
              ),
            ),
            Text(json),
            Container(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                      controller: _username,
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder())),
                  Container(
                    height: 5,
                  ),
                  TextField(
                      controller: _email,
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                          label: Text("Email"), border: OutlineInputBorder())),
                  Container(
                    height: 5,
                  ),
                  TextField(
                      controller: _password,
                      obscureText: true,
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                          label: Text("Password"),
                          border: OutlineInputBorder())),
                  Container(
                    height: 8,
                  ),
                  FilledButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.blue)),
                      child: const Text("Cadastrar"),
                      onPressed: () async {
                        if (_password.text.isNotEmpty &&
                            _username.text.isNotEmpty &&
                            _email.text.isNotEmpty) {
                          var response = await http.post(url, body: {
                            'username': _username.text,
                            'email': _email.text,
                            'password': _password.text
                          });
                          print('Response status: ${response.statusCode}');

                          print('Response body: ${response.body}');
                          var responseJson = jsonDecode(response.body);
                          User user = User.fromJson(responseJson);
                          Navigator.of(context).pushReplacementNamed("/chat");
                          print(user.username);
                          _username.text = '';
                          _email.text = '';
                          _password.text = '';
                        }
                      }),
                  Container(
                    height: 15,
                  ),
                  TextButton(
                      child: const Text(
                        "login",
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      })
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
