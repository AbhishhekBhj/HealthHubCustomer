import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';

import '../../utils/custom_textStyles.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(

      child: Column(children: [
        Text(onboard3MainLogo, style: interBold(fontSize:30),

        
        
        
        ),
        Text(onboard3SubLogo, style: interRegular(fontSize:16),

        
        
        ),
      ],),
    );
  }
}