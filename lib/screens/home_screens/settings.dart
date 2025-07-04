import 'package:flutter/material.dart';
import '../setting_screen/faq.dart';
import '../setting_screen/offline_branch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedTabIndex = 0; // 0 for FAQ, 1 for Locations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Tab Selector Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                children: [
                  _buildTabButton('FAQs', 0),
                  const SizedBox(width: 10),
                  _buildTabButton('Locations', 1),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 10),
            // Tab Content Section
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: IndexedStack(
                  key: ValueKey<int>(selectedTabIndex),  // Key added for animation
                  index: selectedTabIndex,
                  children: [
                    FAQScreen(showAppBar: false),
                    const OfflineBranchesScreen(showAppBar: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds tab toggle buttons with elevation and rounded corners
  Widget _buildTabButton(String text, int index) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.5),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blueAccent : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
