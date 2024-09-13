import 'package:flutter/material.dart';
import 'package:healthhubcustomer/utils/app_constants.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      child: 
      Column(
        children: [
          Text(onboard1MainLogo, style: interBold(
            fontSize: 30
          ),
          
          
          
          ),

          Text(onboard1SubLogo, style: interRegular(
            fontSize: 16
          ),
          
          
          
          ),
        ],
      ),
    );
  }
}