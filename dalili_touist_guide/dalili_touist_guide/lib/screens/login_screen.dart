import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalili_tourist_guide/core/extensions/context_extensions.dart';
import 'package:dalili_tourist_guide/providres/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import 'admin/admin_dashboard_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isImageLoading = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // قائمة الصور الديناميكية
  final List<String> backgroundImages = [
    'https://images.unsplash.com/photo-1566492031773-4f4e4465f4a5?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1549118650-1ab3c9769296?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1572252009286-2686d1f8c2b9?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1557411732-1797a6a6973a?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1200&h=800&fit=crop&crop=center',
  ];

  late String currentImage;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectRandomImage();
  }

  void _selectRandomImage() {
    setState(() {
      _isImageLoading = true;
    });

    final random = Random();
    int newIndex;

    if (backgroundImages.length > 1) {
      do {
        newIndex = random.nextInt(backgroundImages.length);
      } while (newIndex == _currentImageIndex);
    } else {
      newIndex = 0;
    }

    _currentImageIndex = newIndex;
    currentImage = backgroundImages[newIndex];

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      body: Stack(
        children: [
          // ============= الخلفية الديناميكية =============
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: Container(
              key: ValueKey<String>(currentImage),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(currentImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.35),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0D47A1).withValues(alpha: 0.2),
                      const Color(0xFF1A237E).withValues(alpha: 0.5),
                      const Color(0xFF0D47A1).withValues(alpha: 0.7),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ============= مؤشر التحميل =============
          if (_isImageLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),

          // ============= المحتوى =============
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============= زر العودة =============
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 200.ms,
                      )
                      .scale(
                        duration: 600.ms,
                        delay: 200.ms,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                      ),

                  const SizedBox(height: 30),

                  // ============= عنوان الصفحة =============
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.welcomeBack,
                        style: GoogleFonts.cairo(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr.loginSubTitle,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 300.ms,
                      )
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 300.ms,
                      ),

                  const SizedBox(height: 40),

                  // ============= حقل البريد الإلكتروني =============
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: context.tr.email,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 400.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 400.ms,
                      ),

                  const SizedBox(height: 16),

                  // ============= حقل كلمة المرور =============
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: context.tr.password,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 500.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 500.ms,
                      ),

                  const SizedBox(height: 12),

                  // ============= خيار "نسيت كلمة المرور" =============
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _showSnackBar(
                          context.tr.resetPasswordSentInfo,
                          const Color(0xFF0D47A1),
                        );
                      },
                      child: Text(
                        context.tr.forgotPassword,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 550.ms,
                      ),

                  const SizedBox(height: 25),

                  // ============= زر تسجيل الدخول =============
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                _showSnackBar(
                                    context.tr.enterEmailAndPassword,
                                    Colors.orange);
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false);
                              final success = await userProvider.signIn(
                                  _emailController.text,
                                  _passwordController.text);

                              if (!mounted) return;
                              setState(() {
                                _isLoading = false;
                              });

                              if (success) {
                                final isAdmin = userProvider.isAdmin;

                                _showSnackBar(
                                  isAdmin
                                      ? context.tr.adminWelcomeMessage
                                      : context.tr.loginSuccess,
                                  Colors.green,
                                );

                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  if (!context.mounted) return;
                                  if (isAdmin) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const AdminDashboardScreen()),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomeScreen()),
                                    );
                                  }
                                });
                              } else {
                                _showSnackBar(
                                    context.tr.loginFailed,
                                    Colors.red);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        shadowColor:
                            const Color(0xFFFF6B6B).withValues(alpha: 0.4),
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.tr.login,
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.login_rounded,
                                  size: 26,
                                ),
                              ],
                            ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 600.ms,
                      )
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        duration: 600.ms,
                        delay: 600.ms,
                      ),

                  const SizedBox(height: 20),

                  // ============= قسم "أو" =============
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.2),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          context.tr.or,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withValues(alpha: 0.2),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 700.ms,
                      ),

                  const SizedBox(height: 20),

                  // ============= أزرار التواصل الاجتماعي =============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook_rounded,
                        color: const Color(0xFF1877F2),
                        label: context.tr.facebook,
                        onTap: () {
                          _showSnackBar('${context.tr.login}... ${context.tr.facebook}',
                              const Color(0xFF0D47A1));
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildSocialButton(
                        icon: Icons.camera_alt_rounded,
                        color: const Color(0xFFE4405F),
                        label: context.tr.instagram,
                        onTap: () {
                          _showSnackBar('${context.tr.login}... ${context.tr.instagram}',
                              const Color(0xFF0D47A1));
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildSocialButton(
                        icon: Icons.email_rounded,
                        color: const Color(0xFFEA4335),
                        label: context.tr.gmail,
                        onTap: () {
                          _showSnackBar('${context.tr.login}... ${context.tr.gmail}',
                              const Color(0xFF0D47A1));
                        },
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 800.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 800.ms,
                      ),

                  const SizedBox(height: 25),

                  // ============= نص إنشاء حساب جديد =============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr.dontHaveAccount,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          context.tr.signup,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 900.ms,
                      ),

                  const SizedBox(height: 10),

                  // ============= مؤشر الصور =============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      min(6, backgroundImages.length),
                      (index) {
                        final isActive = index == _currentImageIndex % 6;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 950.ms,
                      ),

                  const SizedBox(height: 8),

                  // ============= زر تغيير الخلفية =============
                  Center(
                    child: GestureDetector(
                      onTap: _selectRandomImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              color: Colors.white.withValues(alpha: 0.4),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.tr.changeBackground,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 1000.ms,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
