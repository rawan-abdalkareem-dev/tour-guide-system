import 'package:dalili_tourist_guide/core/extensions/context_extensions.dart';
import 'package:dalili_tourist_guide/providres/user_provider.dart';
import 'package:dalili_tourist_guide/widgets/backgruond_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeTerms = false;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        imageUrl:
            'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=1200&h=800&fit=crop&crop=center',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  iconSize: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr.signup,
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr.welcomeSubtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 35),
                _buildTextField(
                  controller: _nameController,
                  hint: context.tr.name,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  hint: context.tr.email,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hint: context.tr.password,
                  icon: Icons.lock_rounded,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hint: context.tr.confirmPassword,
                  icon: Icons.lock_outline_rounded,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeTerms = value!;
                        });
                      },
                      activeColor: Colors.white,
                      checkColor: const Color(0xFF0D47A1),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        context.tr.termsOfServiceSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (!_agreeTerms) {
                              _showSnackBar(context.tr.termsOfServiceSubtitle,
                                  Colors.orange);
                              return;
                            }
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              _showSnackBar(
                                  context.tr.passwordsDoNotMatch, Colors.red);
                              return;
                            }
                            if (_passwordController.text.length < 6) {
                              _showSnackBar(
                                  context.tr.passwordTooShort,
                                  Colors.orange);
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            final success = await Provider.of<UserProvider>(
                                    context,
                                    listen: false)
                                .signUp(
                              _nameController.text,
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (!mounted) return;
                            setState(() {
                              _isLoading = false;
                            });

                            if (success) {
                              _showSnackBar(
                                  context.tr.signupSuccess, Colors.green);
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()),
                              );
                            } else {
                              _showSnackBar(context.tr.fieldRequired,
                                  Colors.red);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            context.tr.signup,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.alreadyHaveAccount,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.tr.login,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.75)),
          suffixIcon: suffixIcon,
          filled: false,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
