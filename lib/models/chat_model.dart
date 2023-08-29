import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/models/chat_meta_model.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';



class ChatModel {
  final String idFrom;
  final Timestamp timestamp;
  final String? message;

  ChatModel(
      {required this.idFrom,
      required this.timestamp,
      this.message});

  Map<String, dynamic> toMap() {
    return {
      'idFrom': idFrom,
      'timestamp': timestamp,
      'message': message,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      idFrom: map['idFrom'],
      timestamp: map['timestamp'],
      message: map['message'],
    );
  }

  bool get isMyMessage  => idFrom == FireStoreRepository().getCurrentUserId();
}
