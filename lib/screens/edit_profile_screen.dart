import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/user_profile_provider.dart';
import '../services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileProvider>(context, listen: false).userProfile;
    _controllers["fullName"] = TextEditingController(text: profile?.fullName ?? '');
    _controllers["username"] = TextEditingController(text: profile?.username ?? '');
    _controllers["phoneNumber"] = TextEditingController(text: profile?.phoneNumber ?? '');
    _controllers["countryCode"] = TextEditingController(text: profile?.countryCode ?? '');
    _controllers["gender"] = TextEditingController(text: profile?.gender ?? '');
    _controllers["dob"] = TextEditingController(text: profile?.dob ?? '');
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final apiUrl = '${dotenv.env['BASE_URL']}/profile/edit';
    final token = await StorageService.getToken();

    final Map<String, dynamic> updateData = {
      "fullName": _controllers["fullName"]!.text.trim(),
      "username": _controllers["username"]!.text.trim(),
      "phoneNumber": _controllers["phoneNumber"]!.text.trim(),
      "countryCode": _controllers["countryCode"]!.text.trim(),
      "gender": _controllers["gender"]!.text.trim(),
      "dob": _controllers["dob"]!.text.trim(),
    };

    // Remove empty values (don't send unchanged fields)
    updateData.removeWhere((key, value) => value.isEmpty);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final updatedProfile = Provider.of<UserProfileProvider>(context, listen: false).userProfile!;
        updateData.forEach((key, value) {
          switch (key) {
            case 'fullName':
              updatedProfile.fullName = value;
              break;
            case 'username':
              updatedProfile.username = value;
              break;
            case 'phoneNumber':
              updatedProfile.phoneNumber = value;
              break;
            case 'countryCode':
              updatedProfile.countryCode = value;
              break;
            case 'gender':
              updatedProfile.gender = value;
              break;
            case 'dob':
              updatedProfile.dob = value;
              break;
          }
        });

        // Update provider and storage
        Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(updatedProfile);
        await StorageService.saveUserProfile(updatedProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        final res = json.decode(response.body);
        throw Exception(res['detail'] ?? 'Unknown error');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildField(String label, String key, TextInputType type) {
    return TextFormField(
      controller: _controllers[key],
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Edit Profile",
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Full Name", "fullName", TextInputType.name),
              const SizedBox(height: 12),
              _buildField("Username", "username", TextInputType.name),
              const SizedBox(height: 12),
              _buildField("Phone Number", "phoneNumber", TextInputType.phone),
              const SizedBox(height: 12),
              _buildField("Country Code", "countryCode", TextInputType.text),
              const SizedBox(height: 12),
              _buildField("Gender", "gender", TextInputType.text),
              const SizedBox(height: 12),
              _buildField("Date of Birth (YYYY-MM-DD)", "dob", TextInputType.datetime),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes", style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
