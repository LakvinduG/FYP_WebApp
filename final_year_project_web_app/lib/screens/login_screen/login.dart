import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/services/auth_service.dart';
import 'package:final_year_project_web_app/model/user.dart';
import 'package:final_year_project_web_app/screens/product_info_screen/product_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project_web_app/components/custom_text_field.dart';
import 'package:final_year_project_web_app/components/app_header.dart';
import 'package:final_year_project_web_app/components/description_text.dart';
import 'package:final_year_project_web_app/components/custom_password_field.dart';
import 'package:logger/logger.dart';
final logger = Logger();

/// LoginScreen
///
/// Allows an existing manufacturer to login to the app.
/// Features:
/// - Username and Password input fields
/// - Stores token and user info in SharedPreferences upon successful login
/// - Navigates to ProductInformationScreen after login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================
  //  FORM & CONTROLLERS
  // =========================
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // =========================
  //  STATE VARIABLES
  // =========================
  bool _isLoading = false;


  // =========================
  //  LOGIN LOGIC
  // =========================
  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final authService = AuthService();
      User user = await authService.manufacturerLogin(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );


      // =========================
      //  STORE USER INFO LOCALLY
      // =========================
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setString('username', user.username);
      await prefs.setString('role', user.role);

      if (user.companyId != null) {
        await prefs.setInt('companyId', user.companyId!);
        logger.d('CompanyId saved: ${prefs.getInt('companyId')}');
      }
      if (user.companyName != null) {
        await prefs.setString('companyName', user.companyName!);
        logger.d('CompanyName saved: ${prefs.getString('companyName')}');
      }
      if (user.registrationNo != null) {
        await prefs.setString('registrationNo', user.registrationNo!);
        logger.d('RegistrationNo saved: ${prefs.getString('registrationNo')}');
      }

      logger.d('Token saved: ${prefs.getString('token')}');
      logger.d('Username saved: ${prefs.getString('username')}');
      logger.d('Role saved: ${prefs.getString('role')}');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductInformationScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // =========================
  //  UI BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  // Left: Description
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: const DescriptionText(),
                    ),
                  ),
                  // Right: Login Form
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          height: 590,
                          width: 400, // Updated width to 400 to match Register
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF613EEA),
                                  ),
                                ),
                                const SizedBox(height: 70),
                                CustomTextField(
                                  controller: _usernameController,
                                  hintText: 'Username',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Username';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25),
                                CustomPasswordField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                ),
                                // Added extra spacing after the password field.
                                const SizedBox(height: 230),
                                _isLoading
                                    ? const CircularProgressIndicator()
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF613EEA),
                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onPressed: _login,
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: const Text.rich(
                                    TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Register',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
