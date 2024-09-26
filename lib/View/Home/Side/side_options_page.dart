import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/View/widgets/custom_list_tile.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/themes.dart';
import 'package:provider/provider.dart';

import '../../../Controller/providers/theme_provider.dart';
import 'Refer&Earn/refer_earn.dart';

class SideOptionsPage extends StatelessWidget {
  const SideOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Side Options'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(),
            buildListTile(
              title: 'Profile',
              icon: Icons.person,
              onTap: () {
                // Handle tile tap
              },
              backgroundColor: appWhiteColor,
              iconColor: appWhiteColor,
              textColor: appWhiteColor,
              elevation: 8.0,
              borderRadius: 20.0,
              gradientColors: [
                appMainColor,
                Colors.blue[200]!,
                // appWhiteColor,
                  const Color.fromARGB(255, 201, 175, 175),

                appWhiteColor
              ], // Gradient background
            ),
            buildListTile(
              title: 'Settings',
              icon: Icons.settings,
              onTap: () {
                // Handle tile tap
              },
              backgroundColor: appWhiteColor,
              iconColor: appWhiteColor,
              textColor: appWhiteColor,
              elevation: 8.0,
              borderRadius: 20.0,
              gradientColors: [
                appMainColor,
                Colors.blue[200]!,
                // appWhiteColor,
                  const Color.fromARGB(255, 201, 175, 175),

                appWhiteColor
              ], // Gradient background
            ),
            buildListTile(
              title: 'Scratch Gift Card',
              icon: Icons.person,
              onTap: () {
                // Handle tile tap
              },
              backgroundColor: appWhiteColor,
              iconColor: appWhiteColor,
              textColor: appWhiteColor,
              elevation: 8.0,
              borderRadius: 20.0,
              gradientColors: [
                appMainColor,
                Colors.blue[200]!,
                // appWhiteColor,
                  const Color.fromARGB(255, 201, 175, 175),

                appWhiteColor
              ], // Gradient background
            ),
            buildListTile(
              title: 'Redeem Coins',
              icon: Icons.person,
              onTap: () {
                // Handle tile tap
              },
              backgroundColor: appWhiteColor,
              iconColor: appWhiteColor,
              textColor: appWhiteColor,
              elevation: 8.0,
              borderRadius: 20.0,
              gradientColors: [
                appMainColor,
                Colors.blue[200]!,
                // appWhiteColor,
                  const Color.fromARGB(255, 201, 175, 175),

                appWhiteColor
              ], // Gradient background
            ),
            buildListTile(
                title: "My Wallet",
                icon: FontAwesomeIcons.wallet,
                onTap: () {
                  context.pushNamed('walletPage');
                },
                backgroundColor: appWhiteColor,
                iconColor: appWhiteColor,
                textColor: appWhiteColor,
                elevation: 8.0,
                borderRadius: 20.0,
                gradientColors: [
                  appMainColor,
                  Colors.blue[200]!,
                  const Color.fromARGB(255, 201, 175, 175),
                  appWhiteColor
                ]),

                buildListTile(
                title: "Refer & Earn",
                icon: FontAwesomeIcons.wallet,
                onTap: () {
                  // Get.to(() => ReferEarn());
                  context.pushNamed('refer');
                },
                backgroundColor: appWhiteColor,
                iconColor: appWhiteColor,
                textColor: appWhiteColor,
                elevation: 8.0,
                borderRadius: 20.0,
                gradientColors: [
                  appMainColor,
                  Colors.blue[200]!,
                  const Color.fromARGB(255, 201, 175, 175),
                  appWhiteColor
                ]),


                SwitchListTile.adaptive(
            title: Text('Switch to ${themeProvider.isLightTheme ? 'Dark' : 'Light'} Theme'),
            value: themeProvider.isLightTheme,
            onChanged: (value) {
              // Set the theme based on the switch value
              themeProvider.setThemeData(
                value ? lightTheme : darkTheme,
              );

            }

                )
      
          ],
        ),
      ),
    );
  }
}
