import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_event.dart';
import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc()
      : super(const ChatListInitState(chatTabType: ChatTabType.messages)) {
    on<ChatListTabChangedEvent>(_onTabChangedEvent);
  }

  void _onTabChangedEvent(event, emit) async {
    emit(ChatListState(chatTabType: event.chatTabType));
  }
}
