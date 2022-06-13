import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String uid, sentBy, message;
  final Timestamp ts;
  // String? previousChatID;
  List<String> seenBy;
  bool isDeleted;
  bool isEdited;
  String image;
  bool isImage;

  ChatMessage(
      {this.uid = '',
      required this.sentBy,
      this.seenBy = const [],
      this.message = '',
      this.isDeleted = false,
      this.isEdited = false,
      this.image = '',
      this.isImage = false,
      ts})
      : ts = ts ?? Timestamp.now();

  static ChatMessage fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatMessage(
        uid: snap.id,
        sentBy: json['sentBy'] ?? '',
        seenBy: json['seenBy'] != null
            ? List<String>.from(json['seenBy'])
            : <String>[],
        message: json['message'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        isEdited: json['isEdited'] ?? false,
        ts: json['ts'] ?? Timestamp.now(),
        isImage: json['isImage'] ?? false,
        image: json['image'] ?? '');
  }

  Map<String, dynamic> get json => {
        'sentBy': sentBy,
        'message': message,
        'seenBy': seenBy,
        'isDeleted': isDeleted,
        'isEdited': isEdited,
        'ts': ts,
        'isImage': isImage,
        'image': image
      };

  static List<ChatMessage> fromQuerySnap(QuerySnapshot snap) {
    try {
      return snap.docs.map(ChatMessage.fromDocumentSnap).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // String get previousMessages {
  //   return previousChatID!;
  // }

  bool hasNotSeenMessage(String uid) {
    return !seenBy.contains(uid);
  }

  Future updateSeen(String userID, String chatroom, String recipient) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatroom)
        .collection('messages')
        .doc(uid)
        .update({
      'seenBy': FieldValue.arrayUnion([userID])
    }).then((value) => {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userID)
                  .collection('messageSnapshot')
                  .doc(chatroom)
                  .update({
                'seenBy': FieldValue.arrayUnion([userID])
              }),
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(recipient)
                  .collection('messageSnapshot')
                  .doc(chatroom)
                  .update({
                'seenBy': FieldValue.arrayUnion([userID])
              }),
            });
  }

  static Stream<List<ChatMessage>> currentChats(String chatroom) =>
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatroom)
          .collection('messages')
          .orderBy('ts')
          .snapshots()
          .map(ChatMessage.fromQuerySnap);

  Future updateMessage(String newMessage, String chatroom) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatroom)
        .collection('messages')
        .doc(uid) //edited
        .update({'message': newMessage, 'isEdited': true});
  }

  Future deleteMessage(String chatroom) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatroom)
        .collection('messages')
        .doc(uid) //edited
        .update({'isDeleted': true});
  }
}
