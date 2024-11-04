import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthProvider extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();
  bool isAvailable = false;
  bool isDeviceSupported = false;

  LocalAuthProvider() {
    init();
  }

  void init() async {
    isAvailable = await _auth.canCheckBiometrics;
    isDeviceSupported = await _auth.isDeviceSupported();
    notifyListeners();
  }

  Future<bool> deviceHasBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      log("Error authenticating: $e");
      return false;
    }
  }
}
