import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/home/chat/chat_details_screen.dart';
import 'package:firebasedemo/modules/home/chat/chat_listing_screen.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  String selectedUserId = '';
  StreamController<List<UserModel>> userStream =
      StreamController<List<UserModel>>.broadcast();

  @override
  void initState() {
    userStream.addStream(FireStoreRepository().fetchChatUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          return StreamBuilder<List<UserModel>>(
              stream: userStream.stream,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    chatStreamBuilder(
                        isMobileView: false,
                        onTileTap: (index) async{
                          selectedUserId = snapshot.data?[index].uid ?? '';
                          setState(() {});
                          debugPrint("selected UserId $selectedUserId");
                          debugPrint('current user ${user?.uid}');
                          FireStoreRepository().initializeChat(
                            secondUserId: selectedUserId,
                            userId: user?.uid ?? ''
                          );
                        }),
                    Expanded(
                      child: ChatDetailsScreen(
                        secondUserId: selectedUserId,
                        isMobileView: false,
                        chatModel:
                            FireStoreRepository().getChatModel(selectedUserId),
                        userId: user?.uid ?? '',
                      ),
                    ),
                  ],
                );
              });
        } else {
          return chatStreamBuilder(
              isMobileView: true,
              onTileTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailsScreen(
                      secondUserId: selectedUserId,
                        isMobileView: true,
                        chatModel:
                            FireStoreRepository().getChatModel(selectedUserId),
                    userId: user?.uid ?? ''),
                  ),
                );
              });
        }
      }),

      /*Center(
        child: BlocBuilder<SignInBloc,AuthState>(
          builder: (context,state) {
            if(state is AuthSuccessState) {
              return Column(
              children: [
                Text(state.displayName ?? ""),
                const SizedBox(
                  height: 20,
                ),
                Text(loggedInUser.userAddress ?? ""),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Sign-out')),
              ],
            );
            }else{
              return const SizedBox.shrink();
            }
          }
        ),
      ),*/
    );
  }

  Widget chatStreamBuilder({
    required bool isMobileView,
    required Function(int index) onTileTap,
  }) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder<List<UserModel>>(
        stream: userStream.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: isMobileView ? size.width : size.width * 0.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
             snapshot.data!.removeWhere((element) => element.uid == user?.uid);
            return ChatListingScreen(
              isMobileView: isMobileView,
              userList: snapshot.data!,
              onTap: onTileTap,
              uid: user?.uid ?? '',
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
