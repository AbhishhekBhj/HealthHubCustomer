import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';

class WalletSkinClass {
  final int id;
  final List<Color> walletColorGradient;
  final Color textColor;
  final Color iconColor;
  final bool isPremium;

  WalletSkinClass({
    required this.id,
    required this.walletColorGradient,
    required this.textColor,
    required this.iconColor,
    this.isPremium = false,
  });
}

class WalletSkinProvider extends ChangeNotifier {


//on init get the selected wallet skin id from shared preference and set the selected skin to the skin with the id

  WalletSkinProvider() {
    _sharedPreferenceHelper.getSelectedWalletSkinId().then((id) {
      _selectedSkin = _allSkins.firstWhere((skin) => skin.id == id);
      notifyListeners();
    });
  }



  final SharedPreferenceHelper  _sharedPreferenceHelper = SharedPreferenceHelper();
  final List<WalletSkinClass> _allSkins = [
    WalletSkinClass(
    id: 1,
    walletColorGradient: [Colors.blue, Colors.purple],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 2,
    walletColorGradient: [Colors.orange, Colors.red],
    textColor: Colors.black,
    iconColor: Colors.black,
  ),
  WalletSkinClass(
    id: 3,
    walletColorGradient: [Colors.green, Colors.teal],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 4,
    walletColorGradient: [Colors.pink, Colors.deepOrange],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 5,
    walletColorGradient: [Colors.yellow, Colors.amber],
    textColor: Colors.black,
    iconColor: Colors.black,
  ),
  WalletSkinClass(
    id: 6,
    walletColorGradient: [Colors.cyan, Colors.indigo],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 7,
    walletColorGradient: [Colors.grey, Colors.blueGrey],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 8,
    walletColorGradient: [Colors.teal, Colors.lime],
    textColor: Colors.black,
    iconColor: Colors.black,
  ),
  WalletSkinClass(
    id: 9,
    walletColorGradient: [Colors.purpleAccent, Colors.pinkAccent],
    textColor: Colors.white,
    iconColor: Colors.white,
  ),
  WalletSkinClass(
    id: 10,
    walletColorGradient: [Colors.lightBlue, Colors.lightGreen],
    textColor: Colors.black,
    iconColor: Colors.black,
  ),
    // Add more skins here
  ];

  late WalletSkinClass _selectedSkin;

  

  List<WalletSkinClass> get allSkins => _allSkins;

  WalletSkinClass get selectedSkin => _selectedSkin;

  void changeSkin(WalletSkinClass newSkin) {
    _selectedSkin = newSkin;
    _sharedPreferenceHelper.saveSelectedWalletSkinId(newSkin.id);
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
