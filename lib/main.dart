
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
        
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        // dinamizar thema
        // brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        '/login':(context) => const LoginPage(),
        '/register':(context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    ); 
  }

}
