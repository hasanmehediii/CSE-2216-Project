import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

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
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 Full Name: ${user['fullName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("🆔 Username: ${user['username']}"),
            Text("📧 Email: ${user['email']}"),
            Text("📞 Phone: ${user['countryCode']} ${user['phoneNumber']}"),
            Text("🚻 Gender: ${user['gender']}"),
            Text("🎂 DOB: ${user['dob']}"),
            Text("🆔 NID: ${user['nid']}"),
            Text("💎 Premium User: ${user['is_premium'] ? 'Yes' : 'No'}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // 🔍 Search Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by username',
                    labelStyle: const TextStyle(color: Colors.indigo),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.blue),
                      onPressed: () => searchUser(searchController.text.trim()),
                    ),
                  ),
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

              // ⏮️ Prev & ⏭️ Next Buttons
              if (!isLoading && !isError)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (skip > 0)
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            skip -= 1;
                            fetchUser();
                          });
                        },
                        icon: const Icon(Icons.navigate_before),
                        label: const Text("Prev", style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade200,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          skip += 1;
                          fetchUser();
                        });
                      },
                      icon: const Icon(Icons.navigate_next),
                      label: const Text("Next", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),


              // 👇 Bottom Lottie Animation
              SizedBox(
                height: 180,
                child: Lottie.asset('assets/gifs/user_profile_loop.json'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
