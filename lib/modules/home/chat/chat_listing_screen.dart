import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:firebasedemo/models/user_model.dart';
import 'package:firebasedemo/modules/home/chat/chat_tile.dart';
import 'package:flutter/material.dart';

class ChatListingScreen extends StatelessWidget {
  const ChatListingScreen({
    super.key,
    required this.onTap,
    required this.userList,
    required this.isMobileView,
    required this.uid,
  });

  final List<UserModel> userList;
  final Function(int index) onTap;
  final bool isMobileView;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: isMobileView ? size.width : size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onTap.call(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ChatTile(
                      userName: userList[index].userName ?? '',
                      lastUserMessage: 'Last Message',
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) {
                AppRoutes.pushNamed(context, routeType: RouteType.splashScreen);
              });
            },
            child: const Text('Logout'),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
