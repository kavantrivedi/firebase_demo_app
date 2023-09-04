import 'package:equatable/equatable.dart';

enum ChatTabType { groups, messages }

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ChatListTabChangedEvent extends ChatListEvent {
  final ChatTabType chatTabType;

  const ChatListTabChangedEvent({
    required this.chatTabType,
  });

  @override
  List<Object?> get props => [chatTabType];
}
