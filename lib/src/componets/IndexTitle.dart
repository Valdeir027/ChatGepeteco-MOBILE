import 'package:chatgepeteco/src/controlers/themecontrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class IndexTitle extends StatelessWidget {
  const IndexTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
        ],
      ),
    );
  }
}