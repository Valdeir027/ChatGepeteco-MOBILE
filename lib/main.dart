import 'package:chatgepeteco/src/pages/chat_page.dart';
import 'package:chatgepeteco/src/pages/home.dart';
import 'package:chatgepeteco/src/pages/login_page.dart';
import 'package:chatgepeteco/src/pages/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        
        primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        '/login':(context) => LoginPage(),
        '/register':(context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    ); 
  }

}
