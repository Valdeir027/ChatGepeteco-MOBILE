import 'dart:convert';

import 'package:chatgepeteco/src/constants.dart';
import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:chatgepeteco/src/pages/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final url = Uri.parse(
      "${Constants.BASEURL}/api/token/");

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
            SvgPicture.string(
              Constants.svgIconChatString,
              colorFilter: ThemeControl.instance.isDarkTheme? const ColorFilter.mode(Colors.white70, BlendMode.srcIn) :const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              width: 50,
              height: 50,
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
                          if (response.statusCode == 200){
                            User user = User.fromJson(json);
                            print(user);
                            Navigator.of(context).pushReplacementNamed("/home");
                            _username.text = '';
                          _password.text = '';  
                          }else {
                          showDialog(context: context, builder: (child){
                            return AlertDialog(
                              title: Text("Error!!",style: TextStyle(color: Colors.red[100]),),
                              content: Text("Não foi possivel efetuar o login."),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text("tentar novamente"))
                              ],
                            );
                          });
                          _username.text = '';
                          _password.text = '';
                          }

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
