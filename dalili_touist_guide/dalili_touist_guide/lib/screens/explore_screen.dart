// lib/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/widgets/app_cached_image.dart';
import '../models/place_model.dart';
import 'place_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String searchQuery;

  const ExploreScreen({super.key, this.searchQuery = ''});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String searchQuery = '';
  String selectedCategory = 'الكل';
  final TextEditingController _searchController = TextEditingController();

  // ✅ قائمة الفئات ديناميكياً من Hive
  List<String> get categories =>
      ['الكل', ...PlacesData.getCategories().map((c) => c.name)];

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchQuery;
    _searchController.text = searchQuery;
  }

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      setState(() {
        searchQuery = widget.searchQuery;
        _searchController.text = searchQuery;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPlaces {
    final allPlaces = PlacesData.getAllPlaces();

    return allPlaces.where((place) {
      final matchesCategory =
          selectedCategory == 'الكل' || place['category'] == selectedCategory;
      final matchesSearch = (place['name'] as String? ?? '').contains(searchQuery) ||
          (place['location'] as String? ?? '').contains(searchQuery) ||
          (place['category'] as String? ?? '').contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final places = filteredPlaces;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient(context),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ============= شريط البحث =============
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.getCardColor(context,
                      lightAlpha: 0.15, darkAlpha: 0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.getCardBorderColor(context),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          cursorColor: Colors.white,
                          textAlign: TextAlign.right,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: context.tr.searchPlaceholder,
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                            hintTextDirection: TextDirection.rtl,
                            filled: false,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    if (searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            // ============= الفئات =============
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  final displayCategoryName = category == 'الكل' ? context.tr.all : category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFFFFB300) : Colors.white)
                            : AppColors.getCardColor(context,
                                lightAlpha: 0.1, darkAlpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                  ? const Color(0xFFFFB300)
                                  : Colors.white)
                              : AppColors.getCardBorderColor(context),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (isDark
                                          ? const Color(0xFFFFB300)
                                          : Colors.white)
                                      .withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        displayCategoryName,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? (isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFF0D47A1))
                              : Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ============= عدد النتائج =============
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${places.length} ${context.tr.placesCountSuffix}',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  if (selectedCategory != 'الكل' || searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = 'الكل';
                          searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          context.tr.clearAll,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ============= قائمة الأماكن =============
            Expanded(
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
                            context.tr.noResultsFound,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.tr.tryChangingSearch,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.4),
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
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
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
                                              horizontal: 6,
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
          ],
        ),
      ),
    );
  }
}
