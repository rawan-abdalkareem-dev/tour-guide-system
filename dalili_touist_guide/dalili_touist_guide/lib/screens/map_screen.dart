import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/storage/preferences_service.dart';
import '../core/widgets/app_cached_image.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> place;
  final List<Map<String, dynamic>>? allPlaces;

  const MapScreen({
    super.key,
    required this.place,
    this.allPlaces,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showAllPlaces = true;
  double _zoomLevel = 1.0;

  // قائمة الأماكن القريبة (محاكاة)
  List<Map<String, dynamic>> get _nearbyPlaces {
    if (widget.allPlaces != null) {
      return widget.allPlaces!
          .where((p) => p['id'] != widget.place['id'])
          .take(5)
          .toList();
    }
    return [];
  }

  LinearGradient _getMapGradient() {
    final mapType = PreferencesService.mapType;
    switch (mapType) {
      case 'قمر صناعي':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A1118),
            Color(0xFF162533),
            Color(0xFF1E3246),
            Color(0xFF0F1A24),
          ],
        );
      case 'تضاريس':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF33691E),
            Color(0xFF5D4037),
            Color(0xFF8D6E63),
          ],
        );
      case 'مختلط':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF0D9488),
            Color(0xFF14B8A6),
          ],
        );
      case 'عادي':
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF0D47A1),
            Color(0xFF42A5F5),
            Color(0xFF4DD0E1),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          context.tr.locationOnMap,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {
              setState(() {
                _zoomLevel = 1.0;
              });
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
          // ============= الخريطة المحاكاة =============
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _getMapGradient(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // شبكة الخريطة المحاكاة
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: MapGridPainter(zoom: _zoomLevel),
                  ),

                  // اسم المدينة في الأعلى
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.place['location'] ?? context.tr.syria,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // نقاط الموقع على الخريطة
                  ..._buildMapMarkers(),

                  // زر التكبير
                  Positioned(
                    bottom: 20,
                    right: 16,
                    child: Column(
                      children: [
                        _buildZoomButton(Icons.add_rounded, () {
                          setState(() {
                            if (_zoomLevel < 2.0) _zoomLevel += 0.2;
                          });
                        }),
                        const SizedBox(height: 8),
                        _buildZoomButton(Icons.remove_rounded, () {
                          setState(() {
                            if (_zoomLevel > 0.4) _zoomLevel -= 0.2;
                          });
                        }),
                      ],
                    ),
                  ),

                  // معلومات الموقع الحالي
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 80,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getCurrentPlace()['name'],
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  _getCurrentPlace()['rating'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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

          // ============= الأماكن القريبة =============
          if (widget.allPlaces != null && _nearbyPlaces.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr.nearbyPlaces,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllPlaces = !_showAllPlaces;
                          });
                        },
                        child: Text(
                          _showAllPlaces ? context.tr.hide : context.tr.seeAll,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_showAllPlaces)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _nearbyPlaces.length,
                        itemBuilder: (context, index) {
                          final place = _nearbyPlaces[index];
                          return _buildNearbyCard(place);
                        },
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // ============= زر عرض التفاصيل =============
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(
                        place: _getCurrentPlace(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.info_rounded),
                label: Text(
                  '${context.tr.viewDetails} ${_getCurrentPlace()['name']}',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
      ),
    );
  }

  // ============= الحصول على المكان الحالي =============
  Map<String, dynamic> _getCurrentPlace() {
    return widget.place;
  }

  // ============= بناء نقاط الخريطة =============
  List<Widget> _buildMapMarkers() {
    List<Widget> markers = [];
    final places =
        _showAllPlaces ? [widget.place, ..._nearbyPlaces] : [widget.place];

    // تحديد مواقع عشوائية على الخريطة لمحاكاة الواقع
    final randomPositions = [
      {'left': 0.25, 'top': 0.30},
      {'left': 0.50, 'top': 0.20},
      {'left': 0.70, 'top': 0.45},
      {'left': 0.30, 'top': 0.60},
      {'left': 0.60, 'top': 0.70},
      {'left': 0.15, 'top': 0.50},
    ];

    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final isMain = place['id'] == widget.place['id'];
      final pos = randomPositions[i % randomPositions.length];

      double left = pos['left']! * MediaQuery.of(context).size.width * 0.85;
      double top = pos['top']! * 250;

      markers.add(
        Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onTap: () {
              if (!isMain) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaceDetailScreen(place: place),
                  ),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isMain ? Colors.red[400] : Colors.blue[400],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isMain
                              ? Colors.red[400]!.withValues(alpha: 0.4)
                              : Colors.blue[400]!.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: isMain ? 4 : 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      isMain ? Icons.location_on_rounded : Icons.place_rounded,
                      color: Colors.white,
                      size: isMain ? 20 : 14,
                    ),
                  ),
                  if (!isMain)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        place['name'],
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  // ============= بطاقة المكان القريب =============
  Widget _buildNearbyCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(place: place),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context, lightAlpha: 0.08, darkAlpha: 0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.getCardBorderColor(context),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCachedImage(
              imageUrl: place['image'] ?? '',
              height: 70,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'],
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        place['rating'].toString(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 10,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        place['location'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= زر التكبير =============
  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

// ============= رسم شبكة الخريطة =============
class MapGridPainter extends CustomPainter {
  final double zoom;

  MapGridPainter({this.zoom = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    // رسم شبكة الشوارع
    final spacing = 30.0 / zoom;

    // خطوط أفقية
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // خطوط عمودية
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // مربعات رئيسية
    final mainPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 2;

    for (double i = 0; i < size.width; i += spacing * 5) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        mainPaint,
      );
    }

    for (double i = 0; i < size.height; i += spacing * 5) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        mainPaint,
      );
    }

    // حدود الخريطة
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      borderPaint,
    );

    // إضافة بعض النقاط العشوائية لتمثيل المباني
    final buildingPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (i * 37).toDouble() % size.width;
      final y = (i * 53).toDouble() % size.height;
      final w = 4.0 + (i % 6);
      final h = 4.0 + (i % 6);
      canvas.drawRect(
        Rect.fromLTWH(x, y, w, h),
        buildingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(MapGridPainter oldDelegate) {
    return oldDelegate.zoom != zoom;
  }
}
