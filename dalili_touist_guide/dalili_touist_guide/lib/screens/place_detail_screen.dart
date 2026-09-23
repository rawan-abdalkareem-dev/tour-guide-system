import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalili_tourist_guide/providres/fanorites_providre.dart';
import 'package:dalili_tourist_guide/screens/booking_from_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/widgets/app_cached_image.dart';
import '../models/place_model.dart';
import 'map_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  int _currentImageIndex = 0;

  // ============= دالة الاتصال =============
  Future<void> _makePhoneCall() async {
    final place = widget.place;
    final phoneNumber = place['phone'] ?? '';

    if (phoneNumber.isEmpty || phoneNumber == 'غير محدد') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.phoneNumberNotAvailable,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange[400],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: cleanPhone);
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.cannotCallNumber,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ============= دالة الاتجاهات =============
  Future<void> _openDirections() async {
    final place = widget.place;
    final lat = place['latitude'] ?? 0.0;
    final lng = place['longitude'] ?? 0.0;

    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    try {
      final Uri uri = Uri.parse(googleMapsUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.cannotOpenMap,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ============= دالة المشاركة =============
  void _sharePlace() {
    final place = widget.place;

    final String shareText = '''
📍 ${place['name']}
📌 ${place['location']}
⭐ التقييم: ${place['rating']}/5
📝 ${place['description']}

🗺️ الموقع على الخريطة:
https://www.google.com/maps/search/?api=1&query=${place['latitude']},${place['longitude']}

📱 تم المشاركة عبر تطبيق "دليلي السياحي"
🇸🇾 اكتشف سوريا
''';

    Clipboard.setData(ClipboardData(text: shareText)).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 24),
              const SizedBox(height: 8),
              Text(
                '✅ ${context.tr.infoCopied}',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr.pasteAnywhere,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 6,
        ),
      );
    }).catchError((error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.shareError,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red[400],
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  // ============= دالة مشاركة مع مربع حوار =============
  void _shareWithDialog() {
    final place = widget.place;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
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
              Text(
                context.tr.sharePlace,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppCachedImage(
                          imageUrl: place['image'] ?? '',
                          width: 60,
                          height: 60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place['name'],
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                place['location'],
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place['rating'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildShareOption(
                      icon: Icons.content_copy_rounded,
                      label: context.tr.copyLink,
                      color: Colors.blue[400]!,
                      onTap: () {
                        Navigator.pop(context);
                        _sharePlace();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildShareOption(
                      icon: Icons.share_rounded,
                      label: context.tr.share,
                      color: Colors.green[400]!,
                      onTap: () {
                        Navigator.pop(context);
                        _sharePlace();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.tr.cancel,
                    style: GoogleFonts.cairo(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final isFav = Provider.of<FavoritesProvider>(context).isFavorite(place);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient(context),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 350,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.getAppBarColor(context),
              foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedImage(
                    imageUrl: place['image'] ?? '',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['name'],
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              place['location'],
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place['rating'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  return IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(place);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? 'تم إزالة ${place['name']} من المفضلة'
                                : 'تم إضافة ${place['name']} إلى المفضلة',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(),
                          ),
                          backgroundColor:
                              isFav ? Colors.red[400] : Colors.green[400],
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: _shareWithDialog,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(context, lightAlpha: 0.1, darkAlpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.getCardBorderColor(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          Icons.access_time_rounded,
                          context.tr.openingHours,
                          place['openingHours'] ?? context.tr.notSpecified,
                        ),
                        _buildInfoItem(
                          Icons.phone_rounded,
                          context.tr.phone,
                          place['phone'] ?? context.tr.notSpecified,
                        ),
                        _buildInfoItem(
                          Icons.language_rounded,
                          context.tr.location,
                          place['website'] ?? context.tr.notSpecified,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 500.ms,
                        delay: 200.ms,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 500.ms,
                        delay: 200.ms,
                      ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr.description,
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 300.ms,
                      ),
                  const SizedBox(height: 12),
                  Text(
                    place['description'],
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.justify,
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 400.ms,
                      ),
                  const SizedBox(height: 25),
                  if (place['images'] != null &&
                      place['images'].length > 1) ...[
                    Text(
                      context.tr.gallery,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(
                          duration: 500.ms,
                          delay: 500.ms,
                        ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: place['images'].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentImageIndex = index;
                              });
                              _showImageDialog(context, place['images'][index]);
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _currentImageIndex == index
                                      ? Colors.amber
                                      : Colors.white.withValues(alpha: 0.2),
                                  width: _currentImageIndex == index ? 3 : 1,
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    place['images'][index],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(
                          duration: 500.ms,
                          delay: 600.ms,
                        ),
                  ],
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(
                            place: place,
                            allPlaces: PlacesData.getAllPlaces(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.getCardColor(context, lightAlpha: 0.1, darkAlpha: 0.8),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.getCardBorderColor(context),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_rounded,
                              size: 50,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              context.tr.mapLocationHelp,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${place['latitude']}, ${place['longitude']}',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                context.tr.viewOnMap,
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 700.ms,
                      ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _makePhoneCall,
                          icon: const Icon(Icons.phone_rounded),
                          label: Text(
                            context.tr.call,
                            style: GoogleFonts.cairo(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapScreen(
                                  place: place,
                                  allPlaces: PlacesData.getAllPlaces(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map_rounded),
                          label: Text(
                            context.tr.mapLabel,
                            style: GoogleFonts.cairo(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 800.ms,
                      ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openDirections,
                          icon: const Icon(Icons.directions_rounded),
                          label: Text(
                            context.tr.directions,
                            style: GoogleFonts.cairo(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareWithDialog,
                          icon: const Icon(Icons.share_rounded),
                          label: Text(
                            context.tr.share,
                            style: GoogleFonts.cairo(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 900.ms,
                      ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFormScreen(place: place),
                          ),
                        );
                      },
                      icon: const Icon(Icons.event_available_rounded),
                      label: Text(
                        context.tr.bookNow,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: 1000.ms,
                      ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
