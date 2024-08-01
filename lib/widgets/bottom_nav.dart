import 'package:flutter/material.dart';
import 'package:gchat/constants/constants.dart';
import 'package:gchat/providers/bottom_nav_provider.dart';
import 'package:gchat/utils/utilities.dart';
import 'package:gchat/widgets/text_styles.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  final bool? showProviderProfile;

  const BottomNav({super.key, this.showProviderProfile});
  @override
  State<StatefulWidget> createState() {
    return _BottomNav();
  }
}

class _BottomNav extends State<BottomNav> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Styles.regularTextStyle('Exit App',
                fontSize: 14, color: ColorConstants.blackColor),
            content: Styles.regularTextStyle('Do you want to exit an App?',
                fontSize: 14, color: ColorConstants.blackColor),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Styles.regularTextStyle('No',
                    fontSize: 14, color: ColorConstants.blackColor),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Styles.regularTextStyle('Yes',
                    fontSize: 14, color: ColorConstants.blackColor),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => model.updateIndex(index, context),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: ColorConstants.themeColor2,
              selectedLabelStyle: const TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              unselectedLabelStyle: const TextStyle(
                  color: ColorConstants.greyColor2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              backgroundColor: Colors.white,
              currentIndex: model.currentIndex,
              items: userBottomTabItems(context)),
          body: SizedBox(
              height: Utilities.deviceHeight(context),
              width: Utilities.deviceWidth(context),
              child: model.children[model.currentIndex]),
        ),
      );
    });
  }

  userBottomTabItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        activeIcon: Image.asset(
          ImageAssets.activeChat,
          width: 27,
          height: 27,
        ),
        icon: Image.asset(
          ImageAssets.noActiveChat,
          width: 27,
          height: 27,
        ),
        label: "Chat",
      ),
      BottomNavigationBarItem(
        activeIcon: Image.asset(
          ImageAssets.activeProfile,
          width: 27,
          height: 27,
        ),
        icon: Image.asset(
          ImageAssets.noActiveProfile,
          width: 27,
          height: 27,
        ),
        label: "Profile",
      ),
    ];
  }
}
