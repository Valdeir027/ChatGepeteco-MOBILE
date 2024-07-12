import 'dart:convert';

import 'package:chatgepeteco/src/pages/models/roomModel.dart';
import 'package:http/http.dart' as http;


class RoomRepository {
  final url =  Uri.parse("http://ec2-18-228-44-147.sa-east-1.compute.amazonaws.com/api/rooms/");
  final List<Room> list= [];

  Future fechRoom() async{
    var response = await http.get(url);
    var responseBody = utf8.decode(response.bodyBytes);
    var data = jsonDecode(responseBody);
    print(data);
    for (dynamic item in data){
      var room = Room.fromJson(item);
      list.add(room);
    }
    return list;
  }

}