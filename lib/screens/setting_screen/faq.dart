import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final bool showAppBar;
  FAQScreen({super.key, this.showAppBar = true});

  final List<Map<String, String>> faq = [
    {'question': 'What is our mission?', 'answer': 'To provide the best service.'},
    {'question': 'How can I open an account?', 'answer': 'You can open an account online or visit our nearest branch.'},
    {'question': 'What services do we offer?', 'answer': 'We offer banking, loans, and investment services.'},
    {'question': 'Do you offer online banking?', 'answer': 'Yes, we have an online banking system for easy access.'},
    {'question': 'Can I apply for a loan online?', 'answer': 'Yes, you can apply for a loan through our website or mobile app.'},
    {'question': 'How do I check my account balance?', 'answer': 'You can check your account balance through our app or online banking portal.'},
    {'question': 'What are the bank’s working hours?', 'answer': 'We are open from 9 AM to 5 PM, Sunday to Thursday.'},
    {'question': 'Is my money safe?', 'answer': 'Yes, we use the latest security systems to protect your data and money.'},
    {'question': 'How do I contact customer support?', 'answer': 'You can contact us through email, phone, or our website.'},
    {'question': 'Where can I find the nearest branch?', 'answer': 'Use our branch locator on the app or visit our website.'},
  ];

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: faq.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(faq[index]['question']!),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(faq[index]['question']!),
                    content: Text(faq[index]['answer']!),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: content,
      );
    } else {
      return content;
    }
  }
}
