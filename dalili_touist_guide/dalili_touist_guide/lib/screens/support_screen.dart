import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  // قائمة الردود التلقائية
  final List<Map<String, String>> _autoResponses = [
    {'keyword': 'مرحبا', 'response': 'مرحباً بك! كيف يمكنني مساعدتك اليوم؟ 😊'},
    {
      'keyword': 'مساعدة',
      'response': 'أنا هنا لمساعدتك! يرجى توضيح المشكلة التي تواجهها.'
    },
    {
      'keyword': 'حجز',
      'response':
          'يمكنك حجز الأماكن السياحية من خلال الضغط على زر "احجز الآن" في صفحة تفاصيل المكان.'
    },
    {
      'keyword': 'مفضلة',
      'response':
          'لإضافة مكان إلى المفضلة، اضغط على أيقونة القلب ♥️ الموجودة في صفحة تفاصيل المكان.'
    },
    {
      'keyword': 'بحث',
      'response':
          'يمكنك البحث عن الأماكن باستخدام شريط البحث في الصفحة الرئيسية.'
    },
    {
      'keyword': 'شكرا',
      'response': 'العفو! يسعدنا مساعدتك. هل هناك شيء آخر يمكنني فعله لك؟ 🙏'
    },
    {
      'keyword': 'مشكلة',
      'response': 'آسف لسماع ذلك! يرجى وصف المشكلة بالتفصيل وسنساعدك في حلها.'
    },
    {
      'keyword': 'تسجيل',
      'response':
          'لتسجيل الدخول، استخدم البريد الإلكتروني وكلمة المرور الخاصة بك. إذا لم يكن لديك حساب، يمكنك إنشاء حساب جديد.'
    },
    {
      'keyword': 'خروج',
      'response':
          'شكراً لاستخدامك تطبيق دليلي السياحي! نتمنى لك يوماً سعيداً. 🌟'
    },
  ];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _addMessage(context.tr.initialSupportGreeting, isBot: true);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String text, {bool isBot = false}) {
    setState(() {
      _messages.add({
        'text': text,
        'isBot': isBot,
        'time': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getAutoResponse(String message) {
    final lowerMessage = message.toLowerCase();
    for (var response in _autoResponses) {
      if (lowerMessage.contains(response['keyword']!.toLowerCase())) {
        return response['response']!;
      }
    }
    return 'شكراً لتواصلك معنا! 📩\nسيتم الرد على استفسارك في أقرب وقت. فريق الدعم يعمل على مدار الساعة.';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // إضافة رسالة المستخدم
    _addMessage(text, isBot: false);
    _messageController.clear();

    // محاكاة كتابة الرد
    setState(() {
      _isTyping = true;
    });

    // تأخير الرد التلقائي
    Future.delayed(Duration(milliseconds: 800 + (text.length ~/ 2)), () {
      if (!mounted) return;
      final response = _getAutoResponse(text);
      setState(() {
        _isTyping = false;
      });
      _addMessage(response, isBot: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.tr.helpAndSupport,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient(context),
        ),
        child: Column(
          children: [
          // ============= رأس المحادثة =============
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  context.tr.supportHeaderNote,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.tr.online,
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: Colors.green[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ============= قائمة الرسائل =============
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(
                  text: message['text'],
                  isBot: message['isBot'],
                  time: message['time'],
                ).animate().fadeIn(duration: 300.ms).slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 300.ms,
                      delay: (50 * index).ms,
                    );
              },
            ),
          ),

          // ============= حقل الإدخال =============
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                // زر المرفقات
                IconButton(
                  icon: const Icon(
                    Icons.attach_file_rounded,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    _showSnackBar(context.tr.attachmentsComingSoon);
                  },
                ),
                // حقل النص
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        textAlign: TextAlign.right,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: context.tr.writeMessageHint,
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                          hintTextDirection: TextDirection.rtl,
                          filled: false,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                // زر الإرسال
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  // ============= Widgets مساعدة =============

  Widget _buildMessageBubble({
    required String text,
    required bool isBot,
    required DateTime time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isBot
                    ? AppColors.getCardColor(context, lightAlpha: 0.1, darkAlpha: 0.8)
                    : const Color(0xFFFF6B6B),
                border: isBot ? Border.all(color: AppColors.getCardBorderColor(context)) : null,
                borderRadius: BorderRadius.only(
                  topLeft: isBot ? Radius.zero : const Radius.circular(15),
                  topRight: isBot ? const Radius.circular(15) : Radius.zero,
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
          if (!isBot)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFF6B6B),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.getAppBarColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                icon: Icons.clear_all_rounded,
                title: context.tr.clearChat,
                onTap: () {
                  Navigator.pop(context);
                  _showClearDialog(context);
                },
              ),
              _buildOptionItem(
                icon: Icons.info_rounded,
                title: context.tr.supportInfo,
                onTap: () {
                  Navigator.pop(context);
                  _showSupportInfo(context);
                },
              ),
              _buildOptionItem(
                icon: Icons.phone_rounded,
                title: context.tr.contactUs,
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('${context.tr.contactUs}... 📞');
                },
              ),
              _buildOptionItem(
                icon: Icons.email_rounded,
                title: context.tr.email,
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar('support@dalili.com 📧');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.getAppBarColor(context),
          title: Text(
            context.tr.clearChat,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            context.tr.clearChatConfirm,
            style: GoogleFonts.cairo(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.cancel,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _addMessage(
                      context.tr.initialSupportGreeting,
                      isBot: true);
                });
                Navigator.pop(context);
                _showSnackBar(context.tr.chatCleared);
              },
              child: Text(
                context.tr.clearAll,
                style: GoogleFonts.cairo(
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSupportInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.getAppBarColor(context),
          title: Text(
            context.tr.supportInfo,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoItem('🕐', context.tr.workingHours, context.tr.workingHoursValue),
              _buildInfoItem('📞', context.tr.phone, '+963 11 1234567'),
              _buildInfoItem('📧', context.tr.email, 'support@dalili.com'),
              _buildInfoItem('💬', context.tr.responseTime, context.tr.responseTimeValue),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.close,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
