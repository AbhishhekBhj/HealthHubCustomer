import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthhubcustomer/View/widgets/custom_appbar.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:healthhubcustomer/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../colors/colors.dart';
import '../../../../utils/app_constants.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({super.key});

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Refer & Earn',
        context: context,
        gradientColors: [Colors.blue, Colors.purple],
        elevation: 6.0,
        borderRadius: 20.0,
        titleStyle: const TextStyle(color: appWhiteColor, fontSize: 22, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: appWhiteColor),
            onPressed: () {
              // Handle info action
            },
          ),
        ],
      ),
      body: Padding(
        padding: HealthHubPadding.allPagesPadding(context),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(referAndEarnText, style: interMedium()),
                const SizedBox(height: 20),
                buildReferCodeContainer(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReferCodeContainer({required double height, required double width}) {
   

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: appMainColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Referral Code',
              style: interMedium().copyWith(color: appWhiteColor, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'ABC123XYZ', // This would be dynamically set
              style: interMedium().copyWith(color: appWhiteColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getShareIcons().asMap().entries.map((entry) {
                final index = entry.key;
                final icon = entry.value;
                return IconButton(
                  icon: Icon(icon, color: appWhiteColor),
                  onPressed: () {
                    getShareFunctions()[index](referAndEarnText);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Function> getShareFunctions() {
    return [
      sendWhatsappMessage,
      (String message) => sendEmail('example@example.com', 'Referral', message),
      (String message) => shareFacebookPost(message),
      (String message) => shareTwitterPost(message),
      (String message) => shareInstagramPost(message),
    ];
  }

  List<IconData> getShareIcons() {
    return [
      FontAwesomeIcons.whatsapp,
      Icons.email,
      FontAwesomeIcons.facebook,
      FontAwesomeIcons.twitter,
      FontAwesomeIcons.instagram,
    ];
  }

  Future<void> sendWhatsappMessage(String message) async {
    final url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch WhatsApp.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendEmail(String email, String subject, String body) async {
    final url = "mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch email client.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> shareFacebookPost(String message) async {
    final url = "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch Facebook.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> shareTwitterPost(String message) async {
    final url = "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch Twitter.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> shareInstagramPost(String message) async {
    final url = "https://www.instagram.com/?url=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch Instagram.');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
