import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gchat/providers/providers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  ProfileSettingProvider({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.prefs,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  Status _status = Status.uninitialized;
  Status get status => _status;

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<bool> setPref(String key, String value) async {
    return await prefs.setString(key, value);
  }

  UploadTask uploadFile(File image, String fileName) {
    final reference = firebaseStorage.ref().child(fileName);
    final uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Future<void> handleSignOut() async {
    // _status = Status.uninitialized;
    _status = Status.authenticating;

    debugPrint("Logge ${await googleSignIn.isSignedIn()}");
    notifyListeners();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } else {
      await firebaseAuth.signOut();
    }
    _status = Status.uninitialized;
    notifyListeners();
  }
}
