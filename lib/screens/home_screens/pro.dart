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
        title: const Text(
          "Get Pro",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background with low opacity text in different languages
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.blueAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 30,
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Text(
                          "Hello",
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      right: 20,
                      child: Transform.rotate(
                        angle: 0.1,
                        child: Text(
                          "こんにちは",
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      left: 40,
                      child: Transform.rotate(
                        angle: -0.05,
                        child: Text(
                          "مرحبا",
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 30,
                      child: Transform.rotate(
                        angle: 0.05,
                        child: Text(
                          "Hola",
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                // Image
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/confused.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upgrade to Pro Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  onPressed: _showPaymentDialog,
                  icon: const Icon(Icons.workspace_premium, size: 28),
                  label: const Text(
                    "Upgrade to Pro",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),

                // Why Upgrade to Pro Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "🏆 Why Upgrade to Pro?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Free Version Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Free Version",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem("✅ Access to daily vocabulary quizzes"),
                          _buildFeatureItem("✅ Basic conversation practice"),
                          _buildFeatureItem("✅ Grammar & pronunciation guides"),
                          _buildFeatureItem("✅ Limited flashcards and exercises"),
                          _buildFeatureItem("🚫 No offline mode", color: Colors.red),
                          _buildFeatureItem("🚫 No personalized learning path", color: Colors.red),
                          _buildFeatureItem("🚫 Ads in app", color: Colors.red),
                          _buildFeatureItem("🚫 No certificate", color: Colors.red),
                          _buildFeatureItem("🚫 No progress tracking", color: Colors.red),
                          _buildFeatureItem("🚫 No access to group speaking clubs", color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pro Version Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pro (Subscription)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueAccent.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem("✅ Everything in Free, plus:"),
                          _buildFeatureItem("✅ 1-on-1 Video Calling Lessons with native speakers"),
                          _buildFeatureItem("✅ AI-powered speaking feedback"),
                          _buildFeatureItem("✅ Unlimited flashcards with spaced repetition"),
                          _buildFeatureItem("✅ Offline access to lessons"),
                          _buildFeatureItem("✅ Personalized curriculum based on your goals"),
                          _buildFeatureItem("✅ Ad-free experience"),
                          _buildFeatureItem("✅ Get certified upon course completion"),
                          _buildFeatureItem("✅ Full progress tracking and analytics"),
                          _buildFeatureItem("✅ Join live group practice sessions"),
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

  Widget _buildFeatureItem(String text, {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.95),
          title: const Text(
            "Choose Payment Method",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.blueAccent, size: 32),
                title: const Text("Visa Card", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Pay with your Visa card"),
                onTap: () {
                  Navigator.of(context).pop();
                  _showVisaPaymentDialog();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.blueAccent.withOpacity(0.1),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.pink, size: 32),
                title: const Text("bKash", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Pay with bKash mobile banking"),
                onTap: () {
                  Navigator.of(context).pop();
                  _showBkashPaymentDialog();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.pink.withOpacity(0.1),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.teal)),
            ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.95),
          title: const Text(
            "Visa Card Payment",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: "Card Number",
                    prefixIcon: const Icon(Icons.credit_card, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.05),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        decoration: InputDecoration(
                          labelText: "MM/YY",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.05),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: InputDecoration(
                          labelText: "CVV",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.05),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Cardholder Name",
                    prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Amount: \$29.99",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueAccent.shade700,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPayment("Visa Card");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Pay Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.95),
          title: const Text(
            "bKash Payment",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: const Icon(Icons.phone, color: Colors.pink),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.pink.withOpacity(0.05),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                decoration: InputDecoration(
                  labelText: "bKash PIN",
                  prefixIcon: const Icon(Icons.lock, color: Colors.pink),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.pink.withOpacity(0.05),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Text(
                "Amount: ৳2,500",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.pink.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.teal)),
            ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Pay Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
        SnackBar(
          content: Text("Payment successful via $method! You are now a Pro user."),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}