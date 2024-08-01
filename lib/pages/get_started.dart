import 'package:flutter/material.dart';
import 'package:gchat/constants/constants.dart';
import 'package:gchat/pages/create_account.dart';
import 'package:gchat/pages/login_page.dart';
import 'package:gchat/utils/utils.dart';
import 'package:gchat/widgets/widgets.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bGColor,
      body: SizedBox(
        height: Utilities.deviceHeight(context),
        width: Utilities.deviceWidth(context),
        child: Column(
          children: [
            HSpace(Utilities.deviceHeight(context) / 3.5),
            Image.asset(
              ImageAssets.logo,
              width: 100,
              height: 100,
            ),
            const HSpace(8),
            Styles.largeBoldTextStyle("Hey!",
                color: ColorConstants.blackColor, fontSize: 36),
            const HSpace(12),
            Styles.regularTextStyle("Welcome to GChat",
                color: ColorConstants.blackColor, fontSize: 16),
            HSpace(Utilities.deviceHeight(context) / 3),
            CustomButton(
                text: "GET STARTED",
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CreateAccount()));
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
                                builder: (context) => const LoginPage()))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
