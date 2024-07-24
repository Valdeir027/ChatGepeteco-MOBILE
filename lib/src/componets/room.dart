import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:chatgepeteco/src/pages/models/roomModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class RoomComponet extends StatefulWidget {
  final Room room;
  const RoomComponet({super.key, required this.room});

  @override
  State<RoomComponet> createState() => _RoomComponetState();
}

class _RoomComponetState extends State<RoomComponet> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeControl.instance.isDarkTheme? Color.fromARGB(23, 82, 93, 141):Colors.grey,
      height: 50,
      width: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(widget.room.nome!)
          ],
        )),
    );
  }
}