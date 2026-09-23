// lib/screens/favorites_screen.dart
import 'package:dalili_tourist_guide/providres/fanorites_providre.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/widgets/app_cached_image.dart';
import '../models/place_model.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient(context),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الصفحة مع زر العودة
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // زر العودة إلى الرئيسية
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '❤️ المفضلة',
                    style: GoogleFonts.cairo(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (favorites.isNotEmpty)
                    Text(
                      '${favorites.length} مكان',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
            // قائمة المفضلة
            Expanded(
              child: favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            context.tr.noFavoritePlaces,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.tr.addFavoritesSubtitle,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.go('/home');
                            },
                            icon: const Icon(Icons.home_rounded),
                            label: Text(
                              context.tr.backToHome,
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
                                vertical: 14,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final place = favorites[index];
                        return GestureDetector(
                          onTap: () {
                            final fullPlace =
                                PlacesData.getAllPlaces().firstWhere(
                              (p) => (place['id'] != null && p['id'] != null)
                                  ? p['id'] == place['id']
                                  : p['name'] == place['name'],
                              orElse: () => place,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PlaceDetailScreen(place: fullPlace),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                AppCachedImage(
                                  imageUrl: place['image'] ?? '',
                                  width: 70,
                                  height: 70,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              place['category'],
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
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
                                            color:
                                                Colors.white.withValues(alpha: 0.5),
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            place['location'],
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withValues(alpha: 0.5),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red[400],
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    favoritesProvider.removeFavorite(place);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'تم إزالة ${place['name']} من المفضلة',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.cairo(),
                                        ),
                                        backgroundColor: Colors.red[400],
                                        duration: const Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
