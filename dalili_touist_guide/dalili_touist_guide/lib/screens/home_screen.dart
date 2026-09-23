import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalili_tourist_guide/providres/fanorites_providre.dart';
import 'package:dalili_tourist_guide/providres/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../models/place_model.dart';
import 'favorites_screen.dart';
import 'booking_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'category_places_screen.dart';
import 'place_detail_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _heroPageController;
  int _currentHeroPage = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // قائمة الصور الدوارة للأماكن المميزة (تؤخذ ديناميكياً من أعلى الأماكن تقييماً)
  List<Map<String, dynamic>> get heroPlaces {
    final all = PlacesData.getAllPlaces();
    if (all.isEmpty) {
      return _defaultHeroPlaces;
    }
    final sorted = List<Map<String, dynamic>>.from(all);
    sorted.sort((a, b) => ((b['rating'] as num?) ?? 0).compareTo((a['rating'] as num?) ?? 0));
    return sorted.take(6).toList();
  }

  static const List<Map<String, dynamic>> _defaultHeroPlaces = [
    {
      'id': 't1',
      'name': 'الجامع الأموي',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFPiZY_64oFFdlD3qYqFm5ncqlWGg0NnMbe2nu_0cKvw&s=10',
      'rating': 4.9,
      'location': 'دمشق',
      'category': 'أماكن تاريخية',
      'description': 'أحد أقدم وأكبر المساجد في العالم',
      'reviews': 1247,
    },
    {
      'id': 'a2',
      'name': 'قلعة الحصن',
      'image':
          'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800&h=600&fit=crop&crop=center',
      'rating': 4.7,
      'location': 'حمص',
      'category': 'أماكن أثرية',
      'description': 'من أهم القلاع المحفوظة من العصور الوسطى',
      'reviews': 856,
    },
  ];

  // أيقونات وألوان الفئات بحسب الاسم مع قيم افتراضية للفئات المخصصة
  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'مطاعم':
        return Icons.restaurant_rounded;
      case 'أنهار وبحار':
        return Icons.water_rounded;
      case 'جبال':
        return Icons.landscape_rounded;
      case 'فنادق':
        return Icons.hotel_rounded;
      case 'حدائق':
        return Icons.park_rounded;
      case 'كافيهات':
        return Icons.local_cafe_rounded;
      case 'أماكن أثرية':
        return Icons.museum_rounded;
      case 'أماكن تاريخية':
        return Icons.history_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  Color _getCategoryColor(String name) {
    switch (name) {
      case 'مطاعم':
        return const Color(0xFFFF6B6B);
      case 'أنهار وبحار':
        return const Color(0xFF4ECDC4);
      case 'جبال':
        return const Color(0xFF6C5CE7);
      case 'فنادق':
        return const Color(0xFFFFA502);
      case 'حدائق':
        return const Color(0xFF2ECC71);
      case 'كافيهات':
        return const Color(0xFFA29BFE);
      case 'أماكن أثرية':
        return const Color(0xFFFD79A8);
      case 'أماكن تاريخية':
        return const Color(0xFFFDCB6E);
      default:
        return const Color(0xFF0984E3);
    }
  }

  // قائمة بيانات الفئات المحدثة حياً من قاعدة البيانات Hive
  List<Map<String, dynamic>> get categories {
    final cats = PlacesData.getCategories();
    return cats.map((c) => {
      'icon': _getCategoryIcon(c.name),
      'name': c.name,
      'color': _getCategoryColor(c.name),
      'count': PlacesData.getCategoryCount(c.name),
      'emoji': c.emoji,
    }).toList();
  }

  List<Widget> get _pages => [
        HomeContent(
          onSearch: _performSearch,
          heroPlaces: heroPlaces,
          categoriesData: categories,
          heroPageController: _heroPageController,
          currentHeroPage: _currentHeroPage,
          onHeroPageChanged: (index) {
            setState(() {
              _currentHeroPage = index;
            });
          },
          onPreviousHero: _previousHero,
          onNextHero: _nextHero,
          onNavigateToPlaceDetail: _navigateToPlaceDetail,
          searchController: _searchController,
          onNavigateToTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        ExploreScreen(searchQuery: _searchText),
        const FavoritesScreen(),
        const BookingScreen(),
        const ProfileScreen(),
      ];

  @override
  void initState() {
    super.initState();
    _heroPageController =
        PageController(viewportFraction: 0.92, initialPage: 0);
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _previousHero() {
    if (_currentHeroPage > 0) {
      _heroPageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextHero() {
    if (_currentHeroPage < heroPlaces.length - 1) {
      _heroPageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _performSearch(String query) {
    setState(() {
      _currentIndex = 1;
      _searchText = query;
    });
  }

  void _navigateToPlaceDetail(Map<String, dynamic> place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailScreen(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: AppColors.navBarGradient(context),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFFB300)
                : Colors.white,
            unselectedItemColor: Colors.white.withValues(alpha: 0.5),
            currentIndex: _currentIndex,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                if (index != 1) {
                  _searchText = '';
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: context.tr.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.explore_rounded),
                label: context.tr.explore,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_rounded),
                label: context.tr.favorites,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.event_note_rounded),
                label: context.tr.bookings,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_rounded),
                label: context.tr.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// محتوى الصفحة الرئيسية (التبويب الأول)
// ============================================================
class HomeContent extends StatelessWidget {
  final Function(String) onSearch;
  final List<Map<String, dynamic>> heroPlaces;
  final List<Map<String, dynamic>> categoriesData;
  final PageController heroPageController;
  final int currentHeroPage;
  final ValueChanged<int>? onHeroPageChanged;
  final VoidCallback onPreviousHero;
  final VoidCallback onNextHero;
  final Function(Map<String, dynamic>) onNavigateToPlaceDetail;
  final TextEditingController searchController;
  final Function(int)? onNavigateToTab;

  const HomeContent({
    super.key,
    required this.onSearch,
    required this.heroPlaces,
    required this.categoriesData,
    required this.heroPageController,
    required this.currentHeroPage,
    this.onHeroPageChanged,
    required this.onPreviousHero,
    required this.onNextHero,
    required this.onNavigateToPlaceDetail,
    required this.searchController,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final userName = userProvider.userName;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient(context),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============= رأس الصفحة =============
                    _buildHeader(
                        context, userName, userProvider, favoritesProvider),
                    const SizedBox(height: 20),

                    // ============= شريط البحث =============
                    _buildSearchBar(context),
                    const SizedBox(height: 20),

                    // ============= وجهات مميزة =============
                    _buildHeroSection(context),
                    const SizedBox(height: 20),

                    // ============= الفئات =============
                    _buildCategoriesSection(context),
                    const SizedBox(height: 30),

                    // ============= إحصائيات سريعة =============
                    _buildStatsSection(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= رأس الصفحة =============
  Widget _buildHeader(
    BuildContext context,
    String userName,
    UserProvider userProvider,
    FavoritesProvider favoritesProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.welcomeGreeting,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            Text(
              userName,
              style: GoogleFonts.cairo(
                fontSize: 24,
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
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userProvider.isAdmin) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardScreen(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_rounded,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        context.tr.adminPanel,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // أيقونة المفضلة مع العداد
            GestureDetector(
              onTap: () {
                onNavigateToTab?.call(2);
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: favoritesProvider.favoritesCount > 0
                          ? Colors.red[400]
                          : Colors.white,
                      size: 28,
                    ),
                  ),
                  if (favoritesProvider.favoritesCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${favoritesProvider.favoritesCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============= شريط البحث =============
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: Colors.white,
                textAlign: TextAlign.right,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onSearch(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: context.tr.searchDestinationHint,
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                  hintTextDirection: TextDirection.rtl,
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final query = searchController.text;
              if (query.isNotEmpty) {
                onSearch(query);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                context.tr.search,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============= وجهات مميزة =============
  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr.featuredDestinations,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                _buildNavButton(
                  icon: Icons.arrow_back_ios_rounded,
                  onTap: onPreviousHero,
                ),
                const SizedBox(width: 8),
                _buildNavButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: onNextHero,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: heroPageController,
            onPageChanged: onHeroPageChanged,
            itemCount: heroPlaces.length,
            itemBuilder: (context, index) {
              final place = heroPlaces[index];
              return GestureDetector(
                onTap: () => onNavigateToPlaceDetail(place),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(place['image']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.darken,
                        ),
                      ),
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.85),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place['name'],
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.location_on_rounded,
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      place['location'],
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  place['rating'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
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
              );
            },
          ),
        ),
      ],
    );
  }

  // ============= الفئات =============
  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr.discoverCategories,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                onNavigateToTab?.call(1);
              },
              child: Text(
                context.tr.seeAll,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categoriesData.length,
          itemBuilder: (context, index) {
            final category = categoriesData[index];
            return _buildCategoryItem(
              emoji: category['emoji'] as String,
              name: category['name'] as String,
              count: category['count'] as int,
              onTap: () {
                final places =
                    PlacesData.getPlacesByCategory(category['name'] as String);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPlacesScreen(
                      categoryName: category['name'] as String,
                      places: places,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ============= إحصائيات سريعة =============
  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('🏛️', context.tr.historicalPlaces, '10'),
          _buildStatItem('🏨', context.tr.hotels, '10'),
          _buildStatItem('🍽️', context.tr.foodPlaces, '10'),
          _buildStatItem('🏞️', context.tr.landmarks, '10'),
        ],
      ),
    );
  }

  // ============= Widgets مساعدة =============

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String emoji,
    required String name,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              name,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          count,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
