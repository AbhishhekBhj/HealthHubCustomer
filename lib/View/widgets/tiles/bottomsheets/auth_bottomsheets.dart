import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthhubcustomer/Controller/providers/local_auth_provider.dart';

class CustomAuthBottomSheet extends StatelessWidget {
  const CustomAuthBottomSheet({super.key});

  // Static method to show the bottom sheet
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const CustomAuthBottomSheet(),
    );
  }

  Future<void> _handleAuthentication(BuildContext context) async {
    final isAuthenticated = await Provider.of<LocalAuthProvider>(
      context,
      listen: false,
    ).authenticate();

    if (!context.mounted) return;

    if (isAuthenticated) {
      Navigator.pop(context);
      _showSnackBar(
        context,
        'Authentication successful!',
        Colors.green,
      );
    } else {
      _showSnackBar(
        context,
        'Authentication failed.',
        Colors.red,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fingerprint,
            size: 80,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          const Text(
            'Authenticate to Proceed',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please use your fingerprint to access this section securely.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _AuthButton(
            onPressed: () => _handleAuthentication(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AuthButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Authenticate',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}