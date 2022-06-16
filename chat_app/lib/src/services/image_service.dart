import 'dart:io';
import 'package:chat_app/src/controllers/navigation/chat_global_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/chat_controller.dart';

class ImageService {
  static updateProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child(
            'profiles/${FirebaseAuth.instance.currentUser!.uid}/${image.path.split('/').last}');
        print(profileRef.fullPath);
        File file = File(image.path);
        print(image.path);
        TaskSnapshot result = await profileRef.putFile(file);
        print(result);
        String publicUrl = await profileRef.getDownloadURL();
        print(publicUrl);
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'image': publicUrl});
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static sendImageInGroup(ChatControllerGlobal ghatControllerGlobal) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child(
            'images/${FirebaseAuth.instance.currentUser!.uid}/${image.path.split('/').last}');
        print(profileRef.fullPath);
        File file = File(image.path);
        print(image.path);
        TaskSnapshot result = await profileRef.putFile(file);
        String publicUrl = await profileRef.getDownloadURL();

        ghatControllerGlobal.sendImageInGroup(
          image: publicUrl,
        );
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static sendImage(ChatController chatController, String recipient) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child(
            'images/${FirebaseAuth.instance.currentUser!.uid}/${image.path.split('/').last}');
        print(profileRef.fullPath);
        File file = File(image.path);
        print(image.path);
        TaskSnapshot result = await profileRef.putFile(file);
        String publicUrl = await profileRef.getDownloadURL();

        chatController.sendMessage(
            isImage: true, image: publicUrl, recipient: recipient);
      } else {}
    } catch (e) {
      print(e);
    }
  }

  static sendFirstImage(ChatController chatController, String recipient) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child(
            'images/${FirebaseAuth.instance.currentUser!.uid}/${image.path.split('/').last}');
        print(profileRef.fullPath);
        File file = File(image.path);
        print(image.path);
        TaskSnapshot result = await profileRef.putFile(file);
        String publicUrl = await profileRef.getDownloadURL();

        chatController.sendFirstMessage(
            isImage: true, image: publicUrl, recipient: recipient);
      } else {}
    } catch (e) {
      print(e);
    }
  }
}
