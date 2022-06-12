import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettingsController {
  blockUser(String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'blockedUser': FieldValue.arrayUnion([uid])
    });
  }

  togglePrivate(bool isPrivate) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isPrivate': !isPrivate});
  }

  removeBlock(String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'blockedUser': FieldValue.arrayRemove([uid])
    });
  }


}
