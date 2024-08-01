import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gchat/constants/constants.dart';
import 'package:gchat/models/models.dart';
import 'package:gchat/providers/providers.dart';
import 'package:gchat/utils/utilities.dart';
import 'package:gchat/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State createState() => ProfileSettingsPageState();
}

class ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late final TextEditingController _controllerName;
  late final TextEditingController _controllerAboutMe;

  String _userId = '';
  String _fullName = '';
  String _aboutMe = '';
  String _avatarUrl = '';
  String _email = '';

  bool _isLoading = false;
  File? _avatarFile;
  late final _settingProvider = context.read<ProfileSettingProvider>();

  @override
  void initState() {
    super.initState();
    _readLocal();
  }

  void _readLocal() {
    setState(() {
      _userId = _settingProvider.getPref(FirestoreConstants.id) ?? "";
      _fullName = _settingProvider.getPref(FirestoreConstants.nickname) ?? "";
      _aboutMe = _settingProvider.getPref(FirestoreConstants.aboutMe) ?? "";
      _avatarUrl = _settingProvider.getPref(FirestoreConstants.photoUrl) ?? "";
      _email = _settingProvider.getPref(FirestoreConstants.email) ?? "";
    });

    _controllerName = TextEditingController(text: _fullName);
    _controllerAboutMe = TextEditingController(text: _aboutMe);
  }

  Future<bool> _pickAvatar() async {
    final imagePicker = ImagePicker();
    final pickedXFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    });
    if (pickedXFile != null) {
      final imageFile = File(pickedXFile.path);
      setState(() {
        _avatarFile = imageFile;
        _isLoading = true;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      // Handle permission denied or permanently denied case
      Fluttertoast.showToast(msg: "Image access permission denied");
      return false;
    }
  }

  Future<void> _uploadFile() async {
    final fileName = _userId;
    final uploadTask = _settingProvider.uploadFile(_avatarFile!, fileName);
    try {
      final snapshot = await uploadTask;
      _avatarUrl = await snapshot.ref.getDownloadURL();
      final updateInfo = UserChat(
        id: _userId,
        photoUrl: _avatarUrl,
        nickname: _fullName,
        aboutMe: _aboutMe,
      );
      _settingProvider
          .updateDataFirestore(FirestoreConstants.pathUserCollection, _userId,
              updateInfo.toJson())
          .then((_) async {
        await _settingProvider.setPref(FirestoreConstants.photoUrl, _avatarUrl);
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Upload success");
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void _handleUpdateData() {
    setState(() {
      _isLoading = true;
    });
    UserChat updateInfo = UserChat(
      id: _userId,
      photoUrl: _avatarUrl,
      nickname: _fullName,
      aboutMe: _aboutMe,
    );
    _settingProvider
        .updateDataFirestore(
            FirestoreConstants.pathUserCollection, _userId, updateInfo.toJson())
        .then((_) async {
      await _settingProvider.setPref(FirestoreConstants.nickname, _fullName);
      await _settingProvider.setPref(FirestoreConstants.aboutMe, _aboutMe);
      await _settingProvider.setPref(FirestoreConstants.photoUrl, _avatarUrl);

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bGColor2,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Styles.largeBoldTextStyle("Profile", fontSize: 36),
        ),
        leadingWidth: Utilities.deviceWidth(context),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HSpace(32),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      CupertinoButton(
                        onPressed: () async {
                          if (await requestStoragePermission()) {
                            _pickAvatar().then((isSuccess) {
                              if (isSuccess) _uploadFile();
                            });
                          }
                        },
                        child: Container(
                          child: _avatarFile == null
                              ? _avatarUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: Image.network(
                                        _avatarUrl,
                                        fit: BoxFit.cover,
                                        width: 76,
                                        height: 76,
                                        errorBuilder: (_, __, ___) {
                                          return const Icon(
                                            Icons.account_circle,
                                            size: 76,
                                            color: ColorConstants.greyColor,
                                          );
                                        },
                                        loadingBuilder:
                                            (_, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return SizedBox(
                                            width: 76,
                                            height: 76,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    ColorConstants.themeColor,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      width: 76,
                                      height: 76,
                                      // padding: EdgeInsets.all(4.r),
                                      decoration: const BoxDecoration(
                                          color: ColorConstants.themeColor3,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Styles.largeBoldTextStyle(
                                            Utilities.getInitials(_fullName),
                                            color: Colors.white,
                                            fontSize: 32),
                                      ),
                                    )
                              : ClipOval(
                                  child: Image.file(
                                    _avatarFile!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      Column(
                        children: [
                          Styles.regularTextStyle(_fullName),
                          const HSpace(4),
                          Styles.regularTextStyle(_email)
                        ],
                      )
                    ],
                  ),
                ),
                const HSpace(32),
                // Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextInput(
                        hintText: 'Full name',
                        controller: _controllerName,
                        onChanged: (value) {
                          _fullName = value!;
                        }),
                  ],
                ),
                const HSpace(40),
                CustomButton(text: "Update", onPressed: _handleUpdateData),
                const HSpace(32),
                CustomButton(
                    backgroundColor: ColorConstants.themeColor2,
                    width: 150,
                    text: "Logout",
                    // textColor: ColorConstants.primaryColor,
                    onPressed: () async =>
                        _settingProvider.handleSignOut().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                            (_) => false,
                          );
                        })),
              ],
            ),
          ),

          // Loading
          Positioned(child: _isLoading ? LoadingView() : SizedBox.shrink()),
        ],
      ),
    );
  }
}
