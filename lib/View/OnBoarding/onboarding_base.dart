import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthhubcustomer/View/OnBoarding/onboarding1.dart';
import 'package:healthhubcustomer/View/OnBoarding/onboarding2.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/shared_preference_helper.dart';

import 'onboarding_3.dart';

class OnboardingBase extends StatefulWidget {
  const OnboardingBase({super.key});

  @override
  State<OnboardingBase> createState() => _OnboardingBaseState();
}

class _OnboardingBaseState extends State<OnboardingBase> {

  SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper();

final List<Widget> _onboardingPages = [
    const Onboarding1(),
    const Onboarding2(),
    const Onboarding3(),
  ];


  int _currentPage = 0;


  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;;
    var width = MediaQuery.of(context).size.width;;
    return SafeArea(
      child: Scaffold(
      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height*0.25,
                child: PageView.builder(itemBuilder: (context, index) {
                  return _onboardingPages[index];
                },
                itemCount: _onboardingPages.length,
                
                controller: _pageController,
                
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                ),
              ),
                
              SizedBox(
                height: height*0.01,
                width: width*0.2,
                child: LinearProgressIndicator(
                
                  value: (_currentPage + 1) / _onboardingPages.length,
                  valueColor: const AlwaysStoppedAnimation<Color>(appMainColor),
                  backgroundColor: Colors.grey,
                ),
              ),

               Container(
          height: height*0.1,
          width: width*0.65,
          
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: HealthhubCustomButton(
            borderRadius: 12,
            backgroundColor: appMainColor,
            textColor: appWhiteColor,
            text: _currentPage < _onboardingPages.length - 1 ? 'Next' : 'Get Started',
            onPressed: ()  {
              if (_currentPage < _onboardingPages.length - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);


                
              } else {
                _sharedPreferenceHelper.saveUserHasSeenOnboarding(true);

                // Get.offAll(() => const SignUpMainPage());
                context.pushNamed('signup');
              }
            },
          ),
        ),
            ],
          ),
        ),


      
      
      
      
      
      
        
      
        
        
      ),
    );
  }
}