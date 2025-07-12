import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserManage extends StatefulWidget {
  const UserManage({super.key});

  @override
  State<UserManage> createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  int skip = 0;
  final int limit = 1;
  Map<String, dynamic>? userData;
  bool isLoading = false;
  bool isError = false;
  final TextEditingController searchController = TextEditingController();

  final String baseUrl = '${dotenv.env['BASE_URL']!}/admin';

  Future<void> fetchUser() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final response = await http.get(Uri.parse('$baseUrl/users?skip=$skip&limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          userData = data[0];
        });
      } else {
        setState(() {
          userData = null;
        });
      }
    } else {
      setState(() {
        isError = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchUser(String username) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    final response = await http.get(Uri.parse('$baseUrl/users/search?username=$username'));

    if (response.statusCode == 200) {
      setState(() {
        userData = jsonDecode(response.body);
        skip = 0; // reset skip when searching
      });
    } else {
      setState(() {
        userData = null;
        isError = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Widget buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name: ${user['fullName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Username: ${user['username']}"),
            Text("Email: ${user['email']}"),
            Text("Phone: ${user['countryCode']} ${user['phoneNumber']}"),
            Text("Gender: ${user['gender']}"),
            Text("DOB: ${user['dob']}"),
            Text("NID: ${user['nid']}"),
            Text("Premium User: ${user['is_premium'] ? 'Yes' : 'No'}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔍 Search Field
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search by username',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => searchUser(searchController.text.trim()),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 20),

              // 🧾 User Info or Loader/Error
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (isError)
                const Center(child: Text('Error fetching user.', style: TextStyle(color: Colors.red)))
              else if (userData != null)
                  buildUserCard(userData!)
                else
                  const Center(child: Text('No user found.')),

              const SizedBox(height: 20),

              // ⏭️ Next Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => skip += 1);
                    fetchUser();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
