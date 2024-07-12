import 'package:chatgepeteco/src/pages/models/repositorys/room_repository.dart';
import 'package:chatgepeteco/src/pages/models/roomModel.dart';
import 'package:flutter/material.dart';

class RoomState {
  final RoomRepository repository;

  final ValueNotifier<bool> isLoading =  ValueNotifier<bool>(false);

  final ValueNotifier<List<Room>> state   = ValueNotifier<List<Room>>([]);

  final ValueNotifier<String> error  = ValueNotifier<String>("");



  RoomState({ required this.repository});

  // ignore: empty_constructor_bodies
  Future getRoom() async {
    isLoading.value = true;
    try {
      final request = await repository.fechRoom();
      state.value = request;
    }catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}