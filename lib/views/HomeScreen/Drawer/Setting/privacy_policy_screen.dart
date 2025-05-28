// ignore_for_file: must_be_immutable

import 'package:astrowaypartner/services/apiHelper.dart';
import 'package:astrowaypartner/utils/config.dart';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

String privacyUrl = "https://lab7.invoidea.in/goldenheart/privacy-policy";

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  APIHelper helper = APIHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
                appBar:  CustomApp(title: "Privacy Policy",isBackButtonExist: true,isHideWallet: true,),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🔒 Privacy Policy - Golden Heart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(

                    "At Golden Heart, we prioritize your privacy and the security of your personal data. This Privacy Policy explains how we collect, use, and protect your information.\n\n"
                    "1. Information We Collect\n\n"
                    "We collect the following data when you use our platform:\n"
                    "- Personal Details (Name, Email, Phone Number)\n"
                    "- Payment Information (processed securely via third-party gateways)\n"
                    "- Session Data (chat/call logs for quality assurance but not message content)\n\n"
                    "2. How We Use Your Data\n\n"
                    "We use your data to:\n"
                    "- Provide and improve our services.\n"
                    "- Process payments securely.\n"
                    "- Prevent fraud and ensure platform security.\n\n"
                    "3. Data Sharing & Security\n\n"
                    "We do not sell your data to third parties.\n"
                    "Data is encrypted and stored securely.\n"
                    "We may share information only if required by law or to prevent abuse.\n\n"
                    "4. Cookies & Tracking\n\n"
                    "We use cookies to enhance user experience and collect analytics data. You can disable cookies in your browser settings.\n\n"
                    "5. User Rights\n\n"
                    "You can request to access, edit, or delete your personal data.\n"
                    "You can opt out of marketing communications at any time.\n\n"
                    "6. Policy Updates\n\n"
                    "We may update this Privacy Policy from time to time. Continued use of the platform means acceptance of the changes.\n\n"
                    "7. Contact Us\n\n"
                    "For privacy-related inquiries, email us at goldenheart@gmail.com.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
        // body: WebViewWidget(controller: controller),
      );
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
    ..loadRequest(Uri.parse(privacyUrl));
}
