import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:provider/provider.dart';

import '../../../../Controller/providers/wallet_skin_provider.dart';

class MyWalletPage extends StatelessWidget {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final walletSkin = Provider.of<WalletSkinProvider>(context).selectedSkin;
    final walletSkinList = Provider.of<WalletSkinProvider>(context).allSkins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Wallet Display
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: walletSkin.walletColorGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 60,
                    color: walletSkin.iconColor,
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: 24,
                          color: walletSkin.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₹ 1000',
                        style: TextStyle(
                          fontSize: 22,
                          color: walletSkin.textColor,
                        ),
                      ),

                      IconButton(onPressed: (){
                        showWalletOptionsDialog(context);
                        
                      }, icon: Icon(Icons.menu))
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            
         
          ],
        ),
      ),
    );
  }

}



//show a dialog

showWalletOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Wallet Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Add Money'),
              onTap: () {
                // Add money to wallet
              },
            ),
            ListTile(
              title: Text('Withdraw Money'),
              onTap: () {
                // Withdraw money from wallet
              },
            ),

            ListTile(
              title: Text("Change Wallet Skin"),
              onTap: (){

                context.pushNamed("skinsPage");
                // Change wallet skin
              }
            )
          ],
        ),
      );
    },
  );
}

