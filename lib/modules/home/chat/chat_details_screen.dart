import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/models/chat_model.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:flutter/material.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({
    super.key,
    required this.isMobileView,
    required this.chatModel,
    required this.userId,
    required this.secondUserId,
  });

  final bool isMobileView;
  final ChatModel chatModel;
  final String userId;
  final String secondUserId;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  Stream<List<ChatModel>> currentChatMessages = const Stream.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('details updated');
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      body: widget.secondUserId.isNotEmpty
          ? StreamBuilder<List<ChatModel>>(
              stream: FireStoreRepository()
                  .getMessages(widget.chatModel, widget.secondUserId),
              builder: (context, snapshot) {
                debugPrint(' snapshot has data ${snapshot.data != null}');
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Expanded(
                        child: snapshot.data?.isNotEmpty ?? false
                            ? ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  return messageWidget(
                                      message:
                                          snapshot.data?[index].message ?? '',
                                      isMyMessage:
                                          snapshot.data?[index].isMyMessage ??
                                              false);
                                },
                              )
                            : const Center(
                                child: Text(
                                  'No Chat History',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextField(
                                textCapitalization: TextCapitalization.none,
                                textAlign: TextAlign.start,
                                autocorrect: true,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Message',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.deepPurpleAccent.withOpacity(0.2),
                                ),
                                onChanged: (value) {},
                                onSubmitted: (value) {
                                  FireStoreRepository().sendMessage(
                                    secondUserId: widget.secondUserId,
                                    message: ChatModel(
                                      message: value,
                                      idFrom: widget.userId,
                                      timestamp: Timestamp.fromDate(
                                        DateTime.now(),
                                      ),
                                    ),
                                  );
                                  textEditingController.clear();
                                },
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            mini: true,
                            child: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              FireStoreRepository().sendMessage(
                                secondUserId: widget.secondUserId,
                                message: ChatModel(
                                    idFrom: widget.userId,
                                    message: textEditingController.text,
                                    timestamp:
                                        Timestamp.fromDate(DateTime.now())),
                              );
                              textEditingController.clear();
                            },
                          ),
                          const SizedBox(
                            width: 16,
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : const Center(
              child: Text(
                'Please Select User to Chat',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
    );
  }

  Widget messageWidget({required String message, required bool isMyMessage}) {
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade100.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(message, textAlign: TextAlign.center, maxLines: 10,overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ],
    );
  }
}
