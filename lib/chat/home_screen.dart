import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_app/chat/bottom_chat_bar.dart';
import 'package:flutter/material.dart';
import 'package:watch_app/chat/styles.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/chat/loading.dart';
import 'package:geocoder/geocoder.dart';
import 'package:watch_app/services/locationinfo.dart';
import 'package:location/location.dart';
import 'package:watch_app/services/getlocation.dart';

class HomeScreen extends StatelessWidget {
  final userloc = GetLocation.getLocation().toString();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final userloc = GetLocation.getLocation().toString();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with people nearby',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[],
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Chats(),
            const BottomChatBar(),
          ],
        ),
      ),
    );
  }
}

class Chats extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

//add location to retrieve chats from current location only
  final Stream<QuerySnapshot> _chatsStream = FirebaseFirestore.instance
      .collection('chats')
      .where('Subloc', isEqualTo: GetLocation.getLocation()) //isEqualTo:
      .orderBy('createdAt', descending: false)
      .snapshots();
//add location filter

  Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('$snapshot.error'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        return Flexible(
          // Flexible prevents overflow error when keyboard is opened
          child: GestureDetector(
            // Close the keyboard if anything else is tapped
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: snapshot.data!.docs.map(
                (DocumentSnapshot doc) {
                  // Doc id
                  String id = doc.id;
                  // Chat data
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;

                  // Chats sent by the current user
                  if (user?.uid == data['owner']) {
                    return SentMessage(data: data);
                  } else {
                    // Chats sent by everyone else
                    return ReceivedMessage(data: data);
                  }
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}

class SentMessage extends StatelessWidget {
  const SentMessage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(), // Dynamic width spacer
          Container(
            constraints: chatConstraints,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 5.0,
              bottom: 5.0,
              right: 5.0,
            ),
            decoration: const BoxDecoration(
              gradient: sent,
              borderRadius: round,
            ),
            child: GestureDetector(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      data['text'],
                      textAlign: TextAlign.right,
                      style: chatText,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://gravatar.com/avatar/dcf5e01121b3426daaa9365f5191ee99?s=400&d=mp&r=x",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: chatConstraints,
            padding: const EdgeInsets.only(
              left: 5.0,
              top: 5.0,
              bottom: 5.0,
              right: 10.0,
            ),
            decoration: const BoxDecoration(
              gradient: received,
              borderRadius: round,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://gravatar.com/avatar/dcf5e01121b3426daaa9365f5191ee99?s=400&d=mp&r=x",
                  ),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    data['text'],
                    textAlign: TextAlign.left,
                    style: chatText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(), // Dynamic width spacer
        ],
      ),
    );
  }
}
