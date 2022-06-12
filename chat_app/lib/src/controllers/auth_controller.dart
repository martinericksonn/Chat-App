import 'dart:async';

import 'package:chat_app/src/controllers/navigation/navigation_service.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/authentication/login_screen.dart';
import 'package:chat_app/src/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../service_locators.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working = true;
  final NavigationService nav = locator<NavigationService>();

  ///initializes the stream on creation
  AuthController() {
    authStream = _auth.authStateChanges().listen(handleAuthUserChanges);
  }

  ///makes sure to dispose of the streaTheme.of(context).colorScheme.primarym when not in use
  @override
  dispose() {
    authStream.cancel();
    super.dispose();
  }

  handleAuthUserChanges(User? event) {
    ///if no user exists, pop everything and show the AuthScreen
    if (event == null) {
      print('no logged in user');
      nav.popUntilFirst();
      nav.pushReplacementNamed(LoginScreen.route);
    }

    ///if a user exists, redirect to home immediately
    if (event != null) {
      print("logged");
      print('logged in user');
      print(event.email);
      nav.pushReplacementNamed(HomeScreen.route);
    }
    error = null;
    working = false;
    currentUser = event;
    notifyListeners();
  }

  Future login(String email, password) async {
    try {
      working = true;
      notifyListeners();
      UserCredential? result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return result;
    } on FirebaseAuthException catch (e) {
      print('gggggggggggggggggggggggggggggggggggg ${e.message}');
      // print(e.code);
      working = false;
      currentUser = null;
      error = e;
      notifyListeners();
      return Future.error(e.message.toString());
    }
  }

  Future ressetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('seneeeeeeeeeeed emailllllllllllllllllllllllllllllll');
      return true;
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return Future.error(error.message.toString());
    }
  }

  Future register(
      {required String email,
      required String password,
      required String username,
      required String age,
      required String gender}) async {
    try {
      working = true;
      notifyListeners();
      UserCredential createdUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (createdUser.user != null) {
        ChatUser userModel = ChatUser(createdUser.user!.uid, username, email,
            age, gender, '', Timestamp.now(), Timestamp.now(), []);

        return FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uid)
            .set(userModel.json)
            .then((value) {
          Geoflutterfire geo = Geoflutterfire();
          GeoFirePoint myLocation = geo.point(latitude: 0, longitude: 0);
          FirebaseFirestore.instance
              .collection('locations')
              .doc(userModel.uid)
              .set({
            'userUID': userModel.uid,
            'isEnable': false,
            'position': myLocation.data
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      print("adsfadsf ${e.message}");
      print(e.code);
      working = false;
      currentUser = null;
      error = e;
      notifyListeners();
      return Future.error(e.message.toString());
    }
  }

  Future logout() async {
    working = true;
    notifyListeners();
    await _auth.signOut();
    working = false;
    notifyListeners();
    return;
  }
}
