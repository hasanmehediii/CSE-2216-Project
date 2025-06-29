import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';

class ProPage extends StatefulWidget {
  const ProPage({super.key});

  @override
  State<ProPage> createState() => _ProPageState();
}

class _ProPageState extends State<ProPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Pro"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background with low opacity text in different languages
          Positioned.fill(
            child: Opacity(
              opacity: 0.05, // Set low opacity for background text
              child: Container(
                color: Colors.blueAccent.withOpacity(0.1), // Optional: add a subtle background color
                child: Stack(
                  children: [
                    // Add text in different languages across the screen
                    Positioned(
                      top: 20,
                      left: 50,
                      child: Text(
                        "Hello",
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 30,
                      child: Text(
                        "こんにちは", // Japanese for "Hello"
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 50,
                      child: Text(
                        "مرحبا", // Arabic for "Hello"
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 40,
                      child: Text(
                        "Hola", // Spanish for "Hello"
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content of the page
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Smaller PNG Image with dynamic scaling
                Container(
                  width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
                  height: MediaQuery.of(context).size.width * 0.3, // 30% of screen width (making it square-like)
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/confused.png'), // Add your PNG file to assets
                      fit: BoxFit.contain,  // Ensures the image fits within the container
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upgrade to Pro Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _showPaymentDialog,
                  icon: const Icon(Icons.workspace_premium, color: Colors.white),
                  label: const Text("Upgrade to Pro", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 30),

                // Why Upgrade to Pro Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "🏆 Why Upgrade to Pro?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Free and Pro Version Comparison using Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Free Version", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 10),
                          Text("✅ Access to daily vocabulary quizzes"),
                          Text("✅ Basic conversation practice"),
                          Text("✅ Grammar & pronunciation guides"),
                          Text("✅ Limited flashcards and exercises"),
                          Text("🚫 No offline mode"),
                          Text("🚫 No personalized learning path"),
                          Text("🚫 Ads in app"),
                          Text("🚫 No certificate"),
                          Text("🚫 No progress tracking"),
                          Text("🚫 No access to group speaking clubs"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pro Version Comparison using Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Pro (Subscription)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 10),
                          Text("✅ Everything in Free, plus:"),
                          Text("✅ 1-on-1 Video Calling Lessons with native speakers"),
                          Text("✅ AI-powered speaking feedback"),
                          Text("✅ Unlimited flashcards with spaced repetition"),
                          Text("✅ Offline access to lessons"),
                          Text("✅ Personalized curriculum based on your goals"),
                          Text("✅ Ad-free experience"),
                          Text("✅ Get certified upon course completion"),
                          Text("✅ Full progress tracking and analytics"),
                          Text("✅ Join live group practice sessions"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Payment Dialogs
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Payment Method"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.blue),
                title: const Text("Visa Card"),
                subtitle: const Text("Pay with your Visa card"),
                onTap: () {
                  Navigator.of(context).pop();
                  _showVisaPaymentDialog();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.pink),
                title: const Text("bKash"),
                subtitle: const Text("Pay with bKash mobile banking"),
                onTap: () {
                  Navigator.of(context).pop();
                  _showBkashPaymentDialog();
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
          ],
        );
      },
    );
  }

  void _showVisaPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Visa Card Payment"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(
                    labelText: "Card Number",
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        decoration: const InputDecoration(labelText: "MM/YY"),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: const InputDecoration(labelText: "CVV"),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Cardholder Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Amount: \$29.99", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPayment("Visa Card");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showBkashPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("bKash Payment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: "bKash PIN",
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text("Amount: ৳2,500", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (phoneController.text.isEmpty || pinController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                } else {
                  Navigator.of(context).pop();
                  _processPayment("bKash");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(String method) async {
    try {
      await Provider.of<UserProfileProvider>(context, listen: false).updatePremiumStatus(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment successful via $method! You are now a Pro user.")),
      );
      Navigator.pushReplacementNamed(context, '/home'); // Navigate back to HomeScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }
}
