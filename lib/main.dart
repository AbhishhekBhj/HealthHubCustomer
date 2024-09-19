import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'Controller/providers/wallet_skin_provider.dart';
import 'Controller/routes/custom_routes.dart';
import 'package:firebase_core/firebase_core.dart';

// import "firebase_options.dart";
//
Future<void> main() async {

  debugRepaintRainbowEnabled  = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

//   await Firebase.initializeApp(

//     options: DefaultFirebaseOptions.currentPlatform,

// );

  // runApp(MyApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WalletSkinProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Theme Demo',
    );
  }
}
