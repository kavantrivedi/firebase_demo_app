import 'package:firebasedemo/models/chat_model.dart';

class ChatDetailModel {
  final bool isMobileView;
  final ChatModel chatModel;
  final String currentUser;
  final String secondUser;

  ChatDetailModel({
    required this.chatModel,
    required this.currentUser,
    required this.secondUser,
    required this.isMobileView,
  });
}
