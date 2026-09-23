import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../core/extensions/context_extensions.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // قائمة الصور الديناميكية - صور سياحية جذابة عالية الجودة
  final List<String> backgroundImages = [
    'https://images.unsplash.com/photo-1566492031773-4f4e4465f4a5?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1549118650-1ab3c9769296?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1572252009286-2686d1f8c2b9?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1557411732-1797a6a6973a?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1555992336-03a23c7b20ee?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1200&h=800&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1200&h=800&fit=crop&crop=center',
  ];

  late String currentImage;
  int _currentImageIndex = 0;
  bool _isImageLoading = true;

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

    // اختيار صورة مختلفة عن الصورة الحالية
    if (backgroundImages.length > 1) {
      do {
        newIndex = random.nextInt(backgroundImages.length);
      } while (newIndex == _currentImageIndex);
    } else {
      newIndex = 0;
    }

    _currentImageIndex = newIndex;
    currentImage = backgroundImages[newIndex];

    // محاكاة تحميل الصورة
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    });
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ============= أيقونة الطائرة مع تأثيرات =============
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.08),
                          blurRadius: 40,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      size: 70,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 700.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(
                        duration: 800.ms,
                      ),

                  const SizedBox(height: 35),

                  // ============= شعار DALILI =============
                  Text(
                    'DALILI',
                    style: GoogleFonts.poppins(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 12,
                      shadows: [
                        Shadow(
                          blurRadius: 25,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 200.ms,
                      )
                      .slideY(
                        begin: -0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 200.ms,
                      ),

                  const SizedBox(height: 5),

                  // ============= كلمة "دليل" =============
                  Text(
                    context.tr.guideText,
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.95),
                      shadows: [
                        Shadow(
                          blurRadius: 12,
                          color: Colors.black.withValues(alpha: 0.4),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 300.ms,
                      )
                      .slideY(
                        begin: -0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 300.ms,
                      ),

                  const SizedBox(height: 55),

                  // ============= خط فاصل مزخرف =============
                  Container(
                    width: 80,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ).animate().scaleX(
                        duration: 500.ms,
                        delay: 400.ms,
                      ),

                  const SizedBox(height: 40),

                  // ============= النص الرئيسي =============
                  Text(
                    context.tr.discoverPlaces,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 400.ms,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 400.ms,
                      ),

                  const SizedBox(height: 10),

                  // ============= النص الفرعي =============
                  Text(
                    context.tr.makeMemories,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withValues(alpha: 0.4),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 500.ms,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 500.ms,
                      ),

                  const Spacer(),

                  // ============= زر البداية =============
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 12,
                        shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr.startExploring,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.arrow_forward_rounded,
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

                  const SizedBox(height: 15),

                  // ============= زر تغيير الخلفية =============
                  GestureDetector(
                    onTap: _selectRandomImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: Colors.white.withValues(alpha: 0.85),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            context.tr.changeBackground,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 700.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 700.ms,
                      ),

                  const SizedBox(height: 18),

                  // ============= نص إنشاء حساب =============
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr.dontHaveAccount,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ],
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
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 800.ms,
                      ),

                  const SizedBox(height: 12),

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
                                      color: Colors.white.withValues(alpha: 0.2),
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
                        delay: 900.ms,
                      ),

                  const SizedBox(height: 15),

                  // ============= رقم الصورة =============
                  Text(
                    '${(_currentImageIndex % backgroundImages.length) + 1} / ${backgroundImages.length}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        delay: 950.ms,
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
