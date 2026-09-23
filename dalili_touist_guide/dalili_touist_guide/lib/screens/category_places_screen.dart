// lib/screens/category_places_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/widgets/app_cached_image.dart';
import 'place_detail_screen.dart';

class CategoryPlacesScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> places;

  const CategoryPlacesScreen({
    super.key,
    required this.categoryName,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
        child: places.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr.noCategoryPlaces,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr.moreComingSoon,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(
                      context.tr.back,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
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
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.getCardColor(context, lightAlpha: 0.1, darkAlpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.getCardBorderColor(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AppCachedImage(
                          imageUrl: place['image'] ?? '',
                          width: 80,
                          height: 80,
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
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
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      place['category'],
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white.withValues(alpha: 0.5),
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    place['location'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
