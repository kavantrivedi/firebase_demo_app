class ChatMetaModel {
  final String chatId;
  final List<String> users;

  ChatMetaModel({required this.chatId, required this.users});

  factory ChatMetaModel.fromMap(Map<String, dynamic> chatMap) {
    return ChatMetaModel(
      chatId: chatMap['chatId'],
      users: chatMap['users'],
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'chatId': chatId,
      'users': users,
    };
  }
}
