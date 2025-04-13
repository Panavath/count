import 'package:count_frontend/main.dart';
import 'package:count_frontend/screens/home_screen.dart';
import 'package:count_frontend/utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:count_frontend/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _weightController = TextEditingController();
    final TextEditingController _weightGoalController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedGender = 'male';
  String _selectedActivityLevel = 'moderately_active';
  DateTime _selectedDate = DateTime.now()
      .subtract(const Duration(days: 365 * 20)); // Default to 20 years ago

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _weightGoalController.dispose();
    super.dispose();
  }

  Future<void> _logInExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('user_id') != null) {
      await Provider.of<UserDataProvider>(context, listen: false).logIn();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No existing user found')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // App Logo
              Hero(
                tag: 'app-logo',
                child: Image.asset(
                  'assets/icon/Count.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Get Started',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Create your account to track your nutrition',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Login Button
              OutlinedButton(
                onPressed: _logInExistingUser,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'LOG IN WITH EXISTING ACCOUNT',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Or divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Registration Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person_outline,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'Weight (kg)',
                            icon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _heightController,
                            label: 'Height (cm)',
                            icon: Icons.height_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                            controller: _weightGoalController,
                            label: 'Weight Goal (kg)',
                            icon: Icons.monitor_weight_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Required' : null,
                          ),
                    const SizedBox(height: 16),
                    _buildDateField(context),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedGender,
                      items: const ['male', 'female'],
                      label: 'Gender',
                      icon: Icons.transgender,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedActivityLevel,
                      items: const [
                        'sedentary',
                        'lightly_active',
                        'moderately_active',
                        'very_active'
                      ],
                      label: 'Activity Level',
                      icon: Icons.directions_run_outlined,
                      onChanged: (value) =>
                          setState(() => _selectedActivityLevel = value!),
                    ),
                    const SizedBox(height: 30),
                    AppButton.fullWidthButton(
                      onPressed: _submitForm,
                      text: 'REGISTER',
                    ), // <- Closing parenthesis added
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon:
            Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onTap: () => _selectDate(context),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.replaceAll('_', ' ').capitalize()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Provider.of<UserDataProvider>(context, listen: false)
          .signUp(
        userName: _usernameController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _selectedGender,
        activityLevel: _selectedActivityLevel,
        dob: _selectedDate,
        weightGoal: double.parse(_weightGoalController.text)
      )
          .then((_) {
        // Navigator.pushReplacementNamed(BuildContext context, '/');

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

        // Navigator.of(context).pushNamedAndRemoveUntil('/routeName', (route) => false);

      //    Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => const BottomNavBarScreen()),
      //   (Route<dynamic> route) => false, // Remove all previous routes
      // );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBarScreen()),
        (route) => false, // Remove all previous routes (clear stack)
      );
     

      });
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
