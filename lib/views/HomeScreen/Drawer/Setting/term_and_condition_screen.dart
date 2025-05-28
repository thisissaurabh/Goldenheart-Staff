// ignore_for_file: must_be_immutable

import 'package:astrowaypartner/utils/config.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
String termsconditionurl = "https://lab7.invoidea.in/goldenheart/terms-condition";

class TermAndConditionScreen extends StatelessWidget {
  TermAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        appBar:  CustomApp(title: "Terms And Condition",isBackButtonExist: true,isHideWallet: true,),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📜 Terms and Conditions - Golden Heart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(

                    "Welcome to Golden Heart! These Terms and Conditions govern your use of our platform, which allows users to connect with paid friends and professional therapists for emotional support. By using our services, you agree to comply with the following terms.\n\n"
                    "1. Acceptance of Terms\n\n"
                    "By accessing or using Golden Heart, you confirm that you have read, understood, and agreed to these Terms and our Privacy Policy. If you do not agree, please do not use our services.\n\n"
                    "2. Services Provided\n\n"
                    "Golden Heart is an online platform that connects users with paid friends and licensed therapists for emotional relief.\n"
                    "We do not provide medical, psychiatric, or emergency support. If you are in crisis, please seek immediate professional help.\n"
                    "Friends are for casual, supportive conversations, while therapists provide professional guidance.\n\n"
                    "3. User Eligibility\n\n"
                    "You must be at least 18 years old to use our services.\n"
                    "You agree to provide accurate and complete information during registration.\n\n"
                    "4. Payment & Subscription\n\n"
                    "Users must pay for sessions before engaging in chats or calls.\n"
                    "Payments are processed securely via third-party payment gateways.\n"
                    "No refunds will be issued once a session has started.\n\n"
                    "5. User Conduct\n\n"
                    "Users must:\n"
                    "✅ Respect all participants (friends and therapists).\n"
                    "✅ Not engage in harassment, hate speech, or inappropriate behavior.\n"
                    "✅ Not request personal or sensitive information from paid friends or therapists.\n"
                    "✅ Not use the platform for illegal, harmful, or misleading activities.\n\n"
                    "Failure to comply may result in suspension or permanent account termination.\n\n"
                    "6. Confidentiality & Communication\n\n"
                    "All conversations remain private between users and service providers.\n"
                    "However, Golden Heart reserves the right to investigate abuse, fraud, or policy violations.\n\n"
                    "7. Termination of Services\n\n"
                    "We reserve the right to suspend or terminate accounts at our discretion if a user violates our policies.\n\n"
                    "8. Liability Disclaimer\n\n"
                    "Golden Heart is a facilitator, not a healthcare provider. We are not responsible for the advice given by therapists or conversations with paid friends.\n"
                    "We are not liable for any damages, emotional distress, or misunderstandings that arise from interactions on our platform.\n\n"
                    "9. Amendments\n\n"
                    "We may update these terms at any time, and continued use of the platform constitutes acceptance of the revised terms.\n\n"
                    "10. Contact Us\n\n"
                    "For questions regarding these terms, contact us at goldenheart@gmail.com",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),);
        // body: WebViewWidget(controller: controller),

  }

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          const CircularProgressIndicator();
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('Terms condition error- > $error');
        },
      ),
    )
    ..loadRequest(Uri.parse(termsconditionurl));
}
