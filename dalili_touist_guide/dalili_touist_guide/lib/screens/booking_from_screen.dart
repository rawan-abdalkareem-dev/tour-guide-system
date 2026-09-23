import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/storage/preferences_service.dart';
import '../core/widgets/app_cached_image.dart';
import '../providres/booking_provider.dart';
import '../providres/user_provider.dart';

class BookingFormScreen extends StatefulWidget {
  final dynamic place;

  const BookingFormScreen({super.key, required this.place});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  int numberOfPeople = 2;
  String selectedTime = '01:00 م';
  bool _isSubmitting = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<String> morningTimeSlots = [
    '09:00 ص',
    '10:00 ص',
    '11:00 ص',
    '12:00 ظ',
  ];

  final List<String> eveningTimeSlots = [
    '01:00 م',
    '03:00 م',
    '05:00 م',
    '07:00 م',
    '09:00 م',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now().add(const Duration(days: 1));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (emailController.text.isEmpty && userProvider.userEmail.isNotEmpty) {
        emailController.text = userProvider.userEmail;
      }
      final userPhone = userProvider.userData?['phoneNumber'] as String?;
      if (phoneController.text.isEmpty &&
          userPhone != null &&
          userPhone.isNotEmpty) {
        phoneController.text = userPhone;
      }
      final userName = userProvider.userName;
      if (nameController.text.isEmpty && userName.isNotEmpty) {
        nameController.text = userName;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  /// حساب سعر الشخص الواحد ديناميكياً بناءً على بيانات المكان
  double get pricePerPerson {
    final rawPrice = widget.place['price']?.toString().trim() ?? '';
    final digitsOnly = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isNotEmpty) {
      final parsed = double.tryParse(digitsOnly);
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }
    if (rawPrice.contains('اقتصادي')) return 5000;
    if (rawPrice.contains('متوسط')) return 15000;
    if (rawPrice.contains('فاخر')) return 35000;
    if (rawPrice.contains('مجاني')) return 0;
    return 5000;
  }

  double get totalPrice => pricePerPerson * numberOfPeople;

  String get placeName => widget.place['name']?.toString() ?? context.tr.appName;
  String get placeImage => widget.place['image']?.toString() ?? '';
  String get placeLocation => widget.place['location']?.toString() ?? context.tr.syria;
  String get placeCategory => widget.place['category']?.toString() ?? '';
  double get placeRating =>
      (widget.place['rating'] as num?)?.toDouble() ?? 4.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getAppBarColor(context),
      appBar: AppBar(
        title: Text(
          context.tr.bookingFormTitle,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============= 1. بطاقة تفاصيل المكان =============
                  _buildPlaceHeaderCard(),

                  const SizedBox(height: 20),

                  // ============= 2. تحديد تاريخ الزيارة =============
                  _buildSectionTitle(context.tr.visitDateSection, context.tr.visitDateSectionSubtitle),
                  const SizedBox(height: 8),
                  _buildDateSelector(),

                  const SizedBox(height: 20),

                  // ============= 3. تحديد وقت الزيارة =============
                  _buildSectionTitle(context.tr.visitTimeSection, context.tr.visitTimeSectionSubtitle),
                  const SizedBox(height: 8),
                  _buildTimeSelector(),

                  const SizedBox(height: 20),

                  // ============= 4. عدد الأشخاص =============
                  _buildSectionTitle(context.tr.numberOfVisitorsSection, context.tr.numberOfVisitorsSectionSubtitle),
                  const SizedBox(height: 8),
                  _buildGuestsSelector(),

                  const SizedBox(height: 20),

                  // ============= 5. معلومات التواصل =============
                  _buildSectionTitle(
                      context.tr.contactDataSection, context.tr.contactDataSectionSubtitle),
                  const SizedBox(height: 8),
                  _buildContactForm(),

                  const SizedBox(height: 20),

                  // ============= 6. ملخص الحجز والتكلفة =============
                  _buildSummaryCard(),

                  const SizedBox(height: 24),

                  // ============= 7. زر تأكيد الحجز =============
                  _buildSubmitButton(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // UI Building Blocks
  // ==========================================

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 78,
              height: 78,
              child: AppCachedImage(
                imageUrl: placeImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (placeCategory.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          placeCategory,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.white.withValues(alpha: 0.75),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        placeLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 3),
                        Text(
                          '$placeRating',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        pricePerPerson > 0
                            ? '${pricePerPerson.toStringAsFixed(0)} ${context.tr.currency}'
                            : context.tr.freeEntry,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: pricePerPerson > 0
                              ? Colors.amber[300]
                              : Colors.greenAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    bool isSameDay(DateTime? a, DateTime b) {
      if (a == null) return false;
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    final isToday = isSameDay(selectedDate, today);
    final isTomorrow = isSameDay(selectedDate, tomorrow);
    final isDayAfterTomorrow = isSameDay(selectedDate, dayAfterTomorrow);
    final isCustomDate = selectedDate != null &&
        !isToday &&
        !isTomorrow &&
        !isDayAfterTomorrow;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Selected Date Action Row
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _pickCustomDate(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? '${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}'
                          : context.tr.selectVisitDate,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      context.tr.change,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Date Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSelectableChip(
                  label: context.tr.today,
                  isSelected: isToday,
                  onTap: () => setState(() => selectedDate = today),
                ),
                const SizedBox(width: 8),
                _buildSelectableChip(
                  label: context.tr.tomorrow,
                  isSelected: isTomorrow,
                  onTap: () => setState(() => selectedDate = tomorrow),
                ),
                const SizedBox(width: 8),
                _buildSelectableChip(
                  label: context.tr.dayAfterTomorrow,
                  isSelected: isDayAfterTomorrow,
                  onTap: () => setState(() => selectedDate = dayAfterTomorrow),
                ),
                const SizedBox(width: 8),
                _buildSelectableChip(
                  label: isCustomDate
                      ? '${context.tr.customDate} (${selectedDate!.day}/${selectedDate!.month})'
                      : context.tr.customDate,
                  icon: Icon(
                    Icons.edit_calendar_rounded,
                    size: 15,
                    color: isCustomDate
                        ? const Color(0xFF0D47A1)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                  isSelected: isCustomDate,
                  onTap: () => _pickCustomDate(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? icon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : const Color(0xFF08275A).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.22),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Morning Slots
          Row(
            children: [
              Icon(Icons.wb_sunny_rounded,
                  size: 15, color: Colors.amber[300]),
              const SizedBox(width: 6),
              Text(
                context.tr.morningSlots,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: morningTimeSlots.map((slot) {
              final isSelected = selectedTime == slot;
              return _buildSelectableChip(
                label: slot,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    selectedTime = slot;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Evening Slots
          Row(
            children: [
              Icon(Icons.nights_stay_rounded,
                  size: 15, color: Colors.lightBlue[200]),
              const SizedBox(width: 6),
              Text(
                context.tr.eveningSlots,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eveningTimeSlots.map((slot) {
              final isSelected = selectedTime == slot;
              return _buildSelectableChip(
                label: slot,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    selectedTime = slot;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestsSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildCounterButton(
                    Icons.remove_rounded,
                    numberOfPeople > 1
                        ? () {
                            setState(() => numberOfPeople--);
                          }
                        : null,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 46),
                    child: Text(
                      '$numberOfPeople',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    Icons.add_rounded,
                    numberOfPeople < 50
                        ? () {
                            setState(() => numberOfPeople++);
                          }
                        : null,
                  ),
                ],
              ),
              Flexible(
                child: Text(
                  numberOfPeople == 1
                      ? context.tr.onePerson
                      : numberOfPeople == 2
                          ? context.tr.twoPeople
                          : '$numberOfPeople ${context.tr.peopleCountSuffix}',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick count chips with horizontal scroll to prevent overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [1, 2, 4, 6, 10].map((c) {
                final isSel = numberOfPeople == c;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildSelectableChip(
                    label: c == 1
                        ? context.tr.onePerson
                        : c == 2
                            ? context.tr.twoPeople
                            : '$c ${context.tr.peopleCountSuffix}',
                    isSelected: isSel,
                    onTap: () => setState(() => numberOfPeople = c),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback? onTap) {
    final isEnabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.white.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEnabled
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.white.withValues(alpha: 0.3),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Customer Name
          TextFormField(
            controller: nameController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: context.tr.holderNameLabel,
              hint: context.tr.holderNameHint,
              icon: Icons.person_outline_rounded,
            ),
            validator: (val) => val == null || val.trim().isEmpty
                ? context.tr.holderNameRequired
                : null,
          ),
          const SizedBox(height: 12),

          // Phone Number
          TextFormField(
            controller: phoneController,
            cursorColor: Colors.white,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (_) => setState(() {}),
            decoration: _inputDecoration(
              label: context.tr.contactPhoneLabel,
              hint: context.tr.contactPhoneHint,
              icon: Icons.phone_rounded,
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return context.tr.phoneRequired;
              }
              if (val.trim().length < 6) {
                return context.tr.phoneTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Email
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: context.tr.bookingEmailLabel,
              hint: 'email@example.com',
              icon: Icons.email_outlined,
            ),
          ),
          const SizedBox(height: 12),

          // Special Notes
          TextFormField(
            controller: notesController,
            cursorColor: Colors.white,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration(
              label: context.tr.extraNotesLabel,
              hint: context.tr.extraNotesHint,
              icon: Icons.notes_rounded,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 13,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.45),
        fontSize: 12,
      ),
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.amberAccent, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildSummaryCard() {
    final dateStr = selectedDate != null
        ? '${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}'
        : context.tr.notSpecified;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded,
                  color: Colors.amber[300], size: 20),
              const SizedBox(width: 8),
              Text(
                context.tr.summaryTitle,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 18),
          _buildSummaryRow(context.tr.place, placeName),
          _buildSummaryRow(context.tr.visitDateTime, '$dateStr • $selectedTime'),
          _buildSummaryRow(context.tr.numberOfVisitors, '$numberOfPeople ${context.tr.peopleCountSuffix}'),
          if (pricePerPerson > 0)
            _buildSummaryRow(
              context.tr.pricePerPerson,
              '${pricePerPerson.toStringAsFixed(0)} ${context.tr.currency}',
            ),
          const Divider(color: Colors.white24, height: 18),
          _buildSummaryRow(
            context.tr.expectedTotalPrice,
            totalPrice > 0
                ? '${totalPrice.toStringAsFixed(0)} ${context.tr.currency}'
                : context.tr.freeEntry,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: isTotal ? 14 : 13,
                color: isTotal ? Colors.white : Colors.white.withValues(alpha: 0.75),
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: isTotal ? 16 : 13,
                color: isTotal ? Colors.amber[300] : Colors.white,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit = !_isSubmitting;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: canSubmit ? () => _handleConfirmBooking() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      totalPrice > 0
                          ? '${context.tr.confirmBooking} (${totalPrice.toStringAsFixed(0)} ${context.tr.currency})'
                          : context.tr.confirmBookingFree,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ==========================================
  // Logic & Actions
  // ==========================================

  Future<void> _pickCustomDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = (selectedDate != null && !selectedDate!.isBefore(today))
        ? DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day)
        : today.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      locale: Locale(context.tr.localeName),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D47A1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: const Color(0xFF0D47A1),
              headerForegroundColor: Colors.white,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.textMuted;
                }
                return const Color(0xFF1E293B);
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF0D47A1);
                }
                return Colors.transparent;
              }),
              todayForegroundColor:
                  WidgetStateProperty.all(const Color(0xFF0D47A1)),
              todayBorder:
                  const BorderSide(color: Color(0xFF0D47A1), width: 1.5),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _handleConfirmBooking() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.selectVisitDate)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUid = userProvider.userData?['uid'] ??
        PreferencesService.currentUserUid ??
        'guest';

    final bookingId = 'bk_${DateTime.now().millisecondsSinceEpoch}';

    final newBooking = Booking(
      id: bookingId,
      userId: currentUid,
      placeId: widget.place['id']?.toString() ?? '',
      placeName: placeName,
      placeImage: placeImage,
      placeLocation: placeLocation,
      bookingDate: DateTime.now(),
      visitDate: selectedDate!,
      numberOfPeople: numberOfPeople,
      totalPrice: totalPrice,
      status: 'pending',
      notes: notesController.text.trim().isNotEmpty
          ? '${notesController.text.trim()} ($selectedTime)'
          : selectedTime,
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : userProvider.userEmail,
    );

    await Provider.of<BookingProvider>(context, listen: false)
        .addBooking(newBooking);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    await _showSuccessDialog(newBooking);
  }

  Future<void> _showSuccessDialog(Booking booking) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final dateStr =
            '${booking.visitDate.year}/${booking.visitDate.month.toString().padLeft(2, '0')}/${booking.visitDate.day.toString().padLeft(2, '0')}';

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  context.tr.bookingSuccess,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  '${context.tr.referenceNumber}${booking.id.substring(booking.id.length - 6)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),

                // Details Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildDialogInfoRow(context.tr.landmark, booking.placeName),
                      _buildDialogInfoRow(
                          context.tr.appointment, '$dateStr • $selectedTime'),
                      _buildDialogInfoRow(
                          context.tr.visitors, '${booking.numberOfPeople} ${context.tr.peopleSuffix}'),
                      _buildDialogInfoRow(
                        context.tr.total,
                        booking.totalPrice > 0
                            ? '${booking.totalPrice.toStringAsFixed(0)} ${context.tr.currency}'
                            : context.tr.freeEntry,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Text(
                  context.tr.bookingUnderReview,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Close and Done Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx); // Close dialog
                      Navigator.pop(context); // Close BookingFormScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.tr.doneAndFollowBookings,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
