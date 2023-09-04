import 'package:equatable/equatable.dart';

import 'chat_list_event.dart';

class ChatListState extends Equatable {
  final ChatTabType chatTabType;
  const ChatListState({
    required this.chatTabType,
  });

  @override
  List<Object?> get props => [chatTabType];
}

class ChatListInitState extends ChatListState {
  const ChatListInitState({required super.chatTabType});

  @override
  List<Object?> get props => [];
}
