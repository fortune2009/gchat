import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gchat/constants/constants.dart';
import 'package:gchat/models/models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  Status _status = Status.uninitialized;

  Status get status => _status;

  String? get userFirebaseId => prefs.getString(FirestoreConstants.id);

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    final result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();
    final documents = result.docs;
    if (documents.length == 0) {
      // Writing data to server because here is a new user
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(firebaseUser.uid)
          .set({
        FirestoreConstants.nickname: firebaseUser.displayName,
        FirestoreConstants.photoUrl: firebaseUser.photoURL,
        FirestoreConstants.id: firebaseUser.uid,
        FirestoreConstants.createdAt:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      });

      // Write data to local storage
      User? currentUser = firebaseUser;
      await prefs.setString(FirestoreConstants.id, currentUser.uid);
      await prefs.setString(
          FirestoreConstants.nickname, currentUser.displayName ?? "");
      await prefs.setString(
          FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.email, currentUser.email ?? "");
    } else {
      // Already sign up, just get data from firestore
      final documentSnapshot = documents.first;
      final userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      await prefs.setString(FirestoreConstants.id, userChat.id);
      await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
      await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
      await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
    }
    _status = Status.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> handleSignIn(
      {required String email, required String password}) async {
    _status = Status.authenticating;
    notifyListeners();

    final firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    // signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    final result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();
    final documents = result.docs;
    if (documents.length == 0) {
      // Writing data to server because here is a new user
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(firebaseUser.uid)
          .set({
        FirestoreConstants.nickname: firebaseUser.displayName,
        FirestoreConstants.photoUrl: firebaseUser.photoURL,
        FirestoreConstants.id: firebaseUser.uid,
        FirestoreConstants.createdAt:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      });

      // Write data to local storage
      User? currentUser = firebaseUser;
      await prefs.setString(FirestoreConstants.id, currentUser.uid);
      await prefs.setString(
          FirestoreConstants.nickname, currentUser.displayName ?? "");
      await prefs.setString(
          FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.email, currentUser.email ?? "");
    } else {
      // Already sign up, just get data from firestore
      final documentSnapshot = documents.first;
      final userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      await prefs.setString(FirestoreConstants.id, userChat.id);
      await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
      await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
      await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
    }
    _status = Status.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    _status = Status.authenticating;
    notifyListeners();

    final firebaseUser = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    firebaseUser?.updateDisplayName(name);
    // signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      _status = Status.authenticateError;
      notifyListeners();
      return false;
    }

    final result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        .get();
    final documents = result.docs;
    if (documents.length == 0) {
      // Writing data to server because here is a new user
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(firebaseUser.uid)
          .set({
        FirestoreConstants.nickname: firebaseUser.displayName,
        FirestoreConstants.photoUrl: firebaseUser.photoURL,
        FirestoreConstants.id: firebaseUser.uid,
        FirestoreConstants.createdAt:
            DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      });

      // Write data to local storage
      User? currentUser = firebaseUser;
      await prefs.setString(FirestoreConstants.id, currentUser.uid);
      await prefs.setString(
          FirestoreConstants.nickname, firebaseUser.displayName ?? "");
      await prefs.setString(
          FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      await prefs.setString(FirestoreConstants.email, currentUser.email ?? "");
    } else {
      // Already sign up, just get data from firestore
      final documentSnapshot = documents.first;
      final userChat = UserChat.fromDocument(documentSnapshot);
      // Write data to local
      await prefs.setString(FirestoreConstants.id, userChat.id);
      await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
      await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
      await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
    }
    _status = Status.authenticated;
    notifyListeners();
    return true;
  }

  void handleException() {
    _status = Status.authenticateException;
    notifyListeners();
  }

  // Future<void> handleSignOut() async {
  //   // _status = Status.uninitialized;
  //   _status = Status.authenticating;
  //   notifyListeners();
  //   if (await googleSignIn.isSignedIn()) {
  //     await googleSignIn.disconnect();
  //     await googleSignIn.signOut();
  //     await firebaseAuth.signOut();
  //   } else {
  //     await firebaseAuth.signOut();
  //   }
  //   _status = Status.uninitialized;
  //   notifyListeners();
  // }
}
