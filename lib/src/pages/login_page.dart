import 'dart:convert';

import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final url = Uri.parse(
      "http://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/api/token/");

  // Crie controladores de texto para cada TextField
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    // Libere os controladores de texto quando o widget for destruído
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      child: const Text("Login"),
                      onPressed: () async {
                        if (_password.text.isNotEmpty &&
                            _username.text.isNotEmpty) {
                          var response = await http.post(url, body: {
                            'username': _username.text,
                            'password': _password.text
                          });
                          var json = jsonDecode(response.body);
                          User user = User.fromJson(json);
                          print(user);
                          Navigator.of(context).pushReplacementNamed("/home");

                          _username.text = '';
                          _password.text = '';
                        }
                      }),
                  Container(
                    height: 15,
                  ),
                  TextButton(
                      child: const Text(
                        "Cadastre-se aqui",
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/register");
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
