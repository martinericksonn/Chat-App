import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettingsController {
  static blockUser(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'blocklist': FieldValue.arrayUnion([uid])
    });

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'blocklistedme':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  static togglePrivate(bool isPrivate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isPrivate': isPrivate});
  }

  static removeBlock(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'blocklist': FieldValue.arrayRemove([uid])
    });
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'blocklistedme':
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }
}
