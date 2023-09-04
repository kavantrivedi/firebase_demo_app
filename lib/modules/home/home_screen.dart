import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/home/chat/chat_listing_screen.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:firebasedemo/routes/route_models/routes_contants.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../routes/route_models/chat_details_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel loggedInUser = UserModel();
  User? user;
  String selectedUserId = '';
  StreamController<List<UserModel>> userStream =
      StreamController<List<UserModel>>.broadcast();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, RouteConstants.signInEmail);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 500) {
          return StreamBuilder<List<UserModel>>(
              stream: FireStoreRepository().fetchChatUser(),
              builder: (context, snapshot) {
                return Row(
                  children: [
                    chatStreamBuilder(
                        isMobileView: false,
                        onTileTap: (index) async {
                          selectedUserId = snapshot.data?[index].uid ?? '';
                          debugPrint(' selected Uid form chat $selectedUserId');
                          FireStoreRepository().initializeChat(
                              secondUserId: selectedUserId,
                              userId: user?.uid ?? '');
                          debugPrint('current user Id ${user?.uid}');
                          setState(() {});
                        }),
                    // Expanded(
                    //   child: ChatDetailsScreen(
                    //     secondUserId: selectedUserId,
                    //     isMobileView: false,
                    //     chatModel:
                    //         FireStoreRepository().getChatModel(selectedUserId),
                    //     userId: user?.uid ?? '',
                    //   ),
                    // ),
                  ],
                );
              });
        } else {
          return StreamBuilder<List<UserModel>>(
            stream: FireStoreRepository().fetchChatUser(),
            builder: (context, snapshot) {
              return chatStreamBuilder(
                isMobileView: true,
                onTileTap: (index) {
                  FireStoreRepository().initializeChat(
                      secondUserId: snapshot.data?[index].uid ?? '',
                      userId: user?.uid ?? '');
                  Navigator.pushReplacementNamed(
                    context,
                    RouteConstants.chatDetailsScreen,
                    arguments: ChatDetailModel(
                      chatModel:
                          FireStoreRepository().getChatModel(selectedUserId),
                      currentUser: user?.uid ?? '',
                      secondUser: selectedUserId,
                      isMobileView: true,
                    ),
                  );
                },
              );
            },
          );
        }
      }),
    );
  }

  Widget chatStreamBuilder({
    required bool isMobileView,
    required Function(int index) onTileTap,
  }) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder<List<UserModel>>(
        stream: FireStoreRepository().fetchChatUser(),
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
