import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Terms & Conditions")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Terms & Conditions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  "Effective Date: August 6, 2025",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                Text(
                  "We respect your privacy. When you use our site or services, we may collect basic personal information like your name, email, and usage data to improve your experience.\n\n"
                  "We do not sell your data. We only share it with trusted providers (e.g., for hosting or payments) and only when necessary.\n"
                  "We use cookies to analyze traffic and personalize content. You can control cookies via your browser settings.\n\n"
                  "Your data is stored securely, and you can contact us anytime to request access, correction, or deletion.\n\n"
                  "For questions, contact: [support@yourcompany.com]",
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
