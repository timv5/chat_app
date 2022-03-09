import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt', descending: true).snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  final chatDocs = chatSnapshot.data!.docs;
                  return ListView.builder(
                      reverse: true,  // order from the bottom to the top
                      itemCount: chatDocs.length,
                      itemBuilder: (ctx, index) => MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userId'] == user!.uid,
                          chatDocs[index]['username'],
                          key: ValueKey(chatDocs[index].id),
                      )
                  );
              }
            );
        }
      }
    );
  }
}
