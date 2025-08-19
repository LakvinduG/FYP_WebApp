import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/services/auth_service.dart';
import 'package:final_year_project_web_app/model/user.dart';
import 'package:final_year_project_web_app/screens/product_Info_screen/product_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project_web_app/components/custom_text_field.dart';
import 'package:final_year_project_web_app/components/app_header.dart';
import 'package:final_year_project_web_app/components/description_text.dart';
import 'package:final_year_project_web_app/components/custom_password_field.dart';
import 'package:logger/logger.dart';
final logger = Logger();

/// RegisterScreen
///
/// Allows a new manufacturer to register an account.
/// Features:
/// - Username, email, password, confirm password fields
/// - Role and Company dropdowns populated dynamically from backend
/// - Stores token and user info in SharedPreferences
/// - Navigates to ProductInformationScreen upon successful registration
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // =========================
  //  FORM & CONTROLLERS
  // =========================
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController        = TextEditingController();
  final TextEditingController _emailController           = TextEditingController();
  final TextEditingController _passwordController        = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // =========================
  //  STATE VARIABLES
  // =========================
  bool _isLoading = false; // Indicates registration request in progress
  bool _isLoadingData = true;  // Indicates dropdown data loading

  String? _selectedRole;
  String? _selectedCompany;

  List<String> _roles = [];
  List<String> _companies = [];


  // =========================
  //  INITIALIZATION
  // =========================
  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  /// Fetch roles and companies from backend to populate dropdowns
  Future<void> _fetchDropdownData() async {
    try {
      final authService = AuthService();
      List<String> roles = await authService.getRoles();
      List<String> companies = await authService.getCompanies();
      setState(() {
        _roles = roles;
        _companies = companies;
        _isLoadingData = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load roles/companies: $e")),
      );
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  // =========================
  //  REGISTRATION LOGIC
  // =========================
  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }
    if (_selectedRole == null || _selectedCompany == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both role and company")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final authService = AuthService();
      User user = await authService.manufacturerRegister(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _selectedRole!,
        _selectedCompany!,
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

      // Navigate to ProductInformationScreen after successful registration
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProductInformationScreen()),
        (Route<dynamic> route) => false,
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
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                        // Right: Register Form
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                width: 400, // Use the same width (400) as in the login screen.
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
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF613EEA),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextField(
                                        controller: _usernameController,
                                        hintText: 'Username',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a username';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      CustomTextField(
                                        controller: _emailController,
                                        hintText: 'Email',
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      CustomPasswordField(
                                        controller: _passwordController,
                                        hintText: 'Password',
                                      ),
                                      const SizedBox(height: 15),
                                      CustomPasswordField(
                                        controller: _confirmPasswordController,
                                        hintText: 'Confirm Password',
                                      ),
                                      const SizedBox(height: 15),
                                      DropdownButtonFormField<String>(
                                        value: _selectedRole,
                                        items: _roles
                                            .map((role) => DropdownMenuItem(
                                                  value: role,
                                                  child: Text(role),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRole = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Select Role',
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a role';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      DropdownButtonFormField<String>(
                                        value: _selectedCompany,
                                        items: _companies
                                            .map((company) => DropdownMenuItem(
                                                  value: company,
                                                  child: Text(company),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCompany = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Select Company',
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a company';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 30),
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
                                                onPressed: _register,
                                                child: const Text(
                                                  'SignUp',
                                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/login');
                                        },
                                        child: const Text.rich(
                                          TextSpan(
                                            text: "Already have an account? ",
                                            style: TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: "Login",
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
