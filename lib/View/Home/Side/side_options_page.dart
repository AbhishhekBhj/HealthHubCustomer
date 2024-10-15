import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/View/widgets/custom_list_tile.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/themes.dart';
import 'package:provider/provider.dart';

import '../../../Controller/functions/utility_functions.dart';
import '../../../Controller/providers/theme_provider.dart';
import 'Refer&Earn/refer_earn.dart';

class SideOptionsPage extends StatelessWidget {
  const SideOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);


    List<Color> gradientColors = themeProvider.isLightTheme
      ? [
          appMainColor,            // Keep the main color for light theme
          Colors.blue[200]!,       // A lighter blue for light theme
          const Color.fromARGB(255, 201, 175, 175), // Lighter shades
          appWhiteColor,           // White for light theme
        ]
      : [
          const Color(0xFF0D47A1), // Deep Blue for dark theme
          const Color(0xFF1976D2), // Mid Blue for contrast
          const Color(0xFF424242), // Darker Gray for dark theme
          const Color(0xFF212121), // Very dark gray to give it a "night" feel
        ];

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
              gradientColors: gradientColors // Gradient background
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
              gradientColors: gradientColors  // Gradient background
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
              gradientColors: gradientColors  // Gradient background
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
              gradientColors: gradientColors  // Gradient background
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
              gradientColors: gradientColors 
                ),

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
              gradientColors: gradientColors ),


               




              

               buildListTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () async {
                  logOut(context);
                },
                backgroundColor: appWhiteColor,
                iconColor: appWhiteColor,
                textColor: appWhiteColor,
                elevation: 8.0,
                borderRadius: 20.0,
              gradientColors: gradientColors ),


                AnimatedSwitcher(
  duration: const Duration(milliseconds: 500),
  transitionBuilder: (child, animation) {
    return ScaleTransition(scale: animation, child: child);
  },
  child: SwitchListTile.adaptive(
    key: ValueKey<bool>(themeProvider.isLightTheme), // Unique key to differentiate child widgets
    value: themeProvider.isLightTheme,
    onChanged: (value) {
      // Toggle between light and dark themes
      themeProvider.setThemeData(value ? lightTheme : darkTheme);
    },
    title: Text(
      themeProvider.isLightTheme ? 'Light Mode' : 'Dark Mode',
      style: TextStyle(
        color: themeProvider.isLightTheme ? Colors.black : Colors.white,
      ),
    ),
  ),
),

      
          ],
        ),
      ),
    );
  }
}
