import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Column(children: [
        Text(onboard2MainLogo, style: interBold(fontSize:30),
        
        
        ),
        Text(onboard2SubLogo, style: interRegular(fontSize:16),
        
        
        ),
      ],),
    );
  }
}