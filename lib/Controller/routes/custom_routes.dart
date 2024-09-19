import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/View/Auth/signup/signup_2.dart';
import 'package:healthhubcustomer/View/Auth/signup/signup_3.dart';
import 'package:healthhubcustomer/View/Auth/signup/signup_page.dart';
import 'package:healthhubcustomer/View/Home/HomeOptions/home_options.dart';
import 'package:healthhubcustomer/View/Home/Side/Wallet/wallet_page.dart';

import '../../View/Home/Activities/activites_page.dart';
import '../../View/Home/Side/Refer&Earn/refer_earn.dart';
import '../../View/Home/Side/Wallet/wallet_skins_page.dart';
import '../../View/Home/Side/side_options_page.dart';
import '../../View/Home/main_home_page.dart';
import '../../View/Home/trainer/trainer_page.dart';
import '../../View/OnBoarding/onboarding_base.dart';
import '../../splash_screen.dart';

final router = GoRouter(routes: [


  GoRoute(path: "/", name: "splash", builder: (context, state) => const SplashScreen()),
  GoRoute(
    path: '/mainhome',
    name: "mainhome",
    builder: (context, state) => MainHomePage(),
  ),

  GoRoute(path: "/onboarding",name: "onboarding", builder: (context, state) => const OnboardingBase(),),

 GoRoute(
  path: "/signup",
  name: 'signup',
  builder: (context, state) => SignUpMainPage(),
),


  GoRoute(path: "/signup2",name: "signup2", builder: (context, state) => const Signup2(),),

  GoRoute(path: "/signup3",name: "signup3", builder: (context, state) => const Signup3(),),

  GoRoute(path: "/home",name: "home", builder: (context, state) => const HomeOptions(),),

  GoRoute(path: "/side",name: "side", builder: (context, state) => const SideOptionsPage(),),

  GoRoute(path: "/trainer",name: "trainer", builder: (context, state) => const TrainerPage(),),

  GoRoute(path: "/refer",name: "refer", builder: (context, state) => const ReferEarn(),),

  GoRoute(path: "/activities",name: "activities", builder: (context, state) => const ActivitesPage(),),


  GoRoute(path: "/walletPage",name: "walletPage", builder: (context, state) =>  MyWalletPage(),),
  GoRoute(path: "/skinsPage", name: "skinsPage", builder: (context, state) => WalletSkinsPage()),
]);
