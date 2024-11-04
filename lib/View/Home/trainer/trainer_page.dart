import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Controller/providers/local_auth_provider.dart';
import '../../widgets/tiles/bottomsheets/auth_bottomsheets.dart';

class TrainerPage extends StatelessWidget {
  const TrainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer Page'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

             await CustomAuthBottomSheet.show(context);
         
        },
        child: const Icon(Icons.fingerprint),
      ),
    );
  }
}