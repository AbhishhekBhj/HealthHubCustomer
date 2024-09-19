import 'package:flutter/material.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:provider/provider.dart';

import '../../../../Controller/providers/wallet_skin_provider.dart';
import '../../../widgets/custom_appbar.dart';

class WalletSkinsPage extends StatelessWidget {
  const WalletSkinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final walletSkinList = Provider.of<WalletSkinProvider>(context).allSkins;

    return Scaffold(
      appBar: customAppBar(title: "Wallet Skins", context: context,backgroundColor: appMainColor),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Added padding for overall spacing
        child: Column(
          children: [
            ...walletSkinList.map((walletSkin) {
              return Card(
                elevation: 4, // Shadow for card
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: walletSkin.walletColorGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 30,
                      color: walletSkin.iconColor,
                    ),
                  ),
                  title: Text(
                    'Skin ${walletSkin.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Tap to select this skin',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Provider.of<WalletSkinProvider>(context, listen: false)
                        .changeSkin(walletSkin);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
