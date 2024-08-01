import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gchat/pages/login_page.dart';
import 'package:gchat/providers/auth_provider.dart';
import 'package:gchat/utils/utilities.dart';
import 'package:gchat/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import 'home_page.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Account Registration in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Account Registration in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Account Registration in success");
        break;
      default:
        break;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Styles.largeBoldTextStyle("Sign Up",
                        color: ColorConstants.blackColor, fontSize: 36),
                    const HSpace(8),
                    Styles.regularTextStyle(
                        "Fill out the fields below to register on \nGChat",
                        color: ColorConstants.textDescriptionColor,
                        fontSize: 14),
                    const HSpace(32),
                    CustomTextInput(
                      hintText: 'Name',
                      controller: name,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const HSpace(16),
                    CustomTextInput(
                      hintText: 'Email',
                      controller: email,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const HSpace(16),
                    CustomTextInput(
                      hintText: 'Password',
                      controller: password,
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                    HSpace(Utilities.keyboardHeight(context) / 4),
                    // HSpace(10),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          authProvider.handleGoogleSignIn().then((isSuccess) {
                            if (isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          }).catchError((error, stackTrace) {
                            Fluttertoast.showToast(msg: error.toString());
                            authProvider.handleException();
                          });
                        },
                        child: Image.asset(
                          ImageAssets.google,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    const HSpace(18),
                    CustomButton(
                        text: "REGISTER",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authProvider
                                .createUserWithEmailAndPassword(
                                name: name.text, email: email.text, password: password.text)
                                .then((isSuccess) {
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              }
                            }).catchError((error, stackTrace) {
                              Fluttertoast.showToast(msg: error.toString());
                              authProvider.handleException();
                            });
                          }
                        }),
                    const HSpace(24),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          // style: TextStyle(),
                          children: [
                            Styles.spanRegular("Already have an account? ",
                                color: ColorConstants.blackColor, fontSize: 14),
                            Styles.spanRegular(" Login",
                                color: ColorConstants.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                recognizer: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: authProvider.status == Status.authenticating
                ? LoadingView()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}