import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_cached_image.dart';
import '../../core/widgets/app_snack_bar.dart';
import '../../data/repositories/places_repository.dart';
import '../../models/category.dart';
import '../../models/place.dart';
import '../place_detail_screen.dart';

/// Admin CMS Screen for managing Syrian tourist landmarks and restaurants
class AdminPlacesScreen extends StatefulWidget {
  const AdminPlacesScreen({super.key});

  @override
  State<AdminPlacesScreen> createState() => _AdminPlacesScreenState();
}

class _AdminPlacesScreenState extends State<AdminPlacesScreen> {
  final PlacesRepository _repository = const PlacesRepository();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  List<Place> _places = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    final places = _repository.getAllPlaces();
    final categories = _repository.getCategories();
    setState(() {
      _places = places;
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showPlaceDialog({Place? placeToEdit}) async {
    final isEditing = placeToEdit != null;
    final nameController = TextEditingController(text: placeToEdit?.name ?? '');
    final nameEnController =
        TextEditingController(text: placeToEdit?.nameEn ?? '');
    final locationController =
        TextEditingController(text: placeToEdit?.location ?? 'دمشق');
    final imageController =
        TextEditingController(text: placeToEdit?.image ?? '');
    final priceController =
        TextEditingController(text: placeToEdit?.price ?? 'متوسط');
    final descController =
        TextEditingController(text: placeToEdit?.description ?? '');
    final ratingController =
        TextEditingController(text: (placeToEdit?.rating ?? 4.5).toString());
    final phoneController =
        TextEditingController(text: placeToEdit?.phone ?? '');
    final openingHoursController = TextEditingController(
        text: placeToEdit?.openingHours ?? '09:00 ص - 11:00 م');
    final websiteController =
        TextEditingController(text: placeToEdit?.website ?? '');
    final latController = TextEditingController(
        text: (placeToEdit != null && placeToEdit.latitude != 0.0)
            ? placeToEdit.latitude.toString()
            : '33.5130');
    final lngController = TextEditingController(
        text: (placeToEdit != null && placeToEdit.longitude != 0.0)
            ? placeToEdit.longitude.toString()
            : '36.3080');
    final newGalleryImageController = TextEditingController();

    List<String> galleryImages = placeToEdit != null
        ? List<String>.from(placeToEdit.images)
        : [];

    String selectedCat = placeToEdit?.category ??
        (_categories.isNotEmpty ? _categories.first.name : 'مطاعم');
    String selectedCatEn = placeToEdit?.categoryEn ??
        (_categories.isNotEmpty ? _categories.first.nameEn : 'Restaurants');

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Widget buildSectionHeader(String title, IconData icon) {
              return Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 8),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.white,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ============= Pinned Header =============
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isEditing
                                ? Icons.edit_location_alt_rounded
                                : Icons.add_location_alt_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isEditing
                                  ? context.tr.editPlaceTitle
                                  : context.tr.addPlaceTitle,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(ctx),
                            color: AppColors.textSecondary,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    // ============= Scrollable Form Content =============
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ----- 1. المعلومات الأساسية -----
                              buildSectionHeader(
                                  context.tr.basicInfoSection, Icons.info_outline_rounded),

                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: context.tr.placeNameArLabel,
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(Icons.place_outlined,
                                      size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? context.tr.enterPlaceNameError
                                    : null,
                              ),
                              const SizedBox(height: 10),

                              TextFormField(
                                controller: nameEnController,
                                decoration: InputDecoration(
                                  labelText: context.tr.placeNameEnLabel,
                                  hintText: 'e.g. Al-Azem Palace',
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(Icons.language_rounded,
                                      size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              DropdownButtonFormField<String>(
                                initialValue:
                                    _categories.any((c) => c.name == selectedCat)
                                        ? selectedCat
                                        : (_categories.isNotEmpty
                                            ? _categories.first.name
                                            : null),
                                decoration: InputDecoration(
                                  labelText: context.tr.placeCategory,
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(
                                      Icons.category_outlined,
                                      size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: _categories.map((c) {
                                  return DropdownMenuItem<String>(
                                    value: c.name,
                                    child: Text('${c.emoji} ${c.name}'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() {
                                      selectedCat = val;
                                      final matched = _categories.firstWhere(
                                        (c) => c.name == val,
                                        orElse: () => const Category(
                                            id: '', name: '', emoji: ''),
                                      );
                                      if (matched.nameEn.isNotEmpty) {
                                        selectedCatEn = matched.nameEn;
                                      }
                                    });
                                  }
                                },
                                validator: (v) =>
                                    v == null ? context.tr.selectCategoryError : null,
                              ),
                              const SizedBox(height: 10),

                              TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  labelText: context.tr.cityRegionLabel,
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(
                                      Icons.location_city_rounded,
                                      size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? context.tr.enterCityError
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              // Quick city chips
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  'دمشق',
                                  'حلب',
                                  'حمص',
                                  'اللاذقية',
                                  'طرطوس',
                                  'حماة',
                                  'تدمر',
                                  'ريف دمشق'
                                ].map((city) {
                                  return ActionChip(
                                    label: Text(city,
                                        style: const TextStyle(fontSize: 11)),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: AppColors.background,
                                    onPressed: () {
                                      setDialogState(() {
                                        locationController.text = city;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),

                              // ----- 2. أوقات العمل ومعلومات التواصل -----
                              buildSectionHeader(context.tr.workingHoursAndContact,
                                  Icons.contact_phone_outlined),

                              TextFormField(
                                controller: openingHoursController,
                                decoration: InputDecoration(
                                  labelText: context.tr.workingHoursLabel,
                                  hintText: context.tr.workingHoursHint,
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(
                                      Icons.access_time_rounded,
                                      size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                children: [
                                  '09:00 ص - 11:00 م',
                                  '12:00 ظ - 12:00 ص',
                                  context.tr.roundTheClock,
                                ].map((hours) {
                                  return ActionChip(
                                    label: Text(hours,
                                        style: const TextStyle(fontSize: 11)),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: AppColors.background,
                                    onPressed: () {
                                      setDialogState(() {
                                        openingHoursController.text = hours;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: context.tr.phoneContactLabel,
                                        hintText: '+963 11 1234567',
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 13),
                                        prefixIcon: const Icon(
                                            Icons.phone_rounded,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: websiteController,
                                      decoration: InputDecoration(
                                        labelText: context.tr.websiteUrlLabel,
                                        hintText: 'www.example.com',
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 13),
                                        prefixIcon: const Icon(
                                            Icons.link_rounded,
                                            size: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ----- 3. الأسعار والتقييم والخريطة -----
                              buildSectionHeader(context.tr.pricesRatingCoordinates,
                                  Icons.tune_rounded),

                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: priceController,
                                      decoration: InputDecoration(
                                        labelText: context.tr.priceLevelLabel,
                                        hintText: context.tr.priceLevelHint,
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 12),
                                        prefixIcon: const Icon(
                                            Icons.payments_outlined,
                                            size: 18),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: ratingController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: context.tr.ratingLabel,
                                        hintText: '4.8',
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 12),
                                        prefixIcon: const Icon(
                                            Icons.star_rounded,
                                            size: 18,
                                            color: Colors.amber),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                children: [
                                  context.tr.budget,
                                  context.tr.moderate,
                                  context.tr.luxury,
                                  context.tr.free
                                ].map((p) {
                                  return ActionChip(
                                    label: Text(p,
                                        style: const TextStyle(fontSize: 11)),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: AppColors.background,
                                    onPressed: () {
                                      setDialogState(() {
                                        priceController.text = p;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: latController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: context.tr.latitudeLabel,
                                        hintText: '33.5130',
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 12),
                                        prefixIcon: const Icon(
                                            Icons.map_outlined,
                                            size: 18),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: lngController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: context.tr.longitudeLabel,
                                        hintText: '36.3080',
                                        labelStyle:
                                            GoogleFonts.cairo(fontSize: 12),
                                        prefixIcon: const Icon(
                                            Icons.map_outlined,
                                            size: 18),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ----- 4. الوصف والنبذة التعريفية -----
                              buildSectionHeader(context.tr.descriptionSection,
                                  Icons.description_outlined),

                              TextFormField(
                                controller: descController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: context.tr.placeDescriptionLabel,
                                  hintText: context.tr.placeDescriptionHint,
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? context.tr.enterDescriptionError
                                    : null,
                              ),

                              // ----- 5. الصور ومعرض الصور -----
                              buildSectionHeader(context.tr.photosAndGallery,
                                  Icons.photo_library_outlined),

                              TextFormField(
                                controller: imageController,
                                decoration: InputDecoration(
                                  labelText: context.tr.mainImageUrlLabel,
                                  hintText: 'https://...',
                                  labelStyle: GoogleFonts.cairo(fontSize: 13),
                                  prefixIcon: const Icon(
                                      Icons.image_outlined,
                                      size: 20),
                                  suffixIcon: imageController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.refresh_rounded,
                                              size: 18),
                                          onPressed: () {
                                            setDialogState(() {});
                                          },
                                        )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (_) => setDialogState(() {}),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? context.tr.enterMainImageError
                                    : null,
                              ),
                              const SizedBox(height: 8),

                              // Main Image Preview
                              if (imageController.text.trim().isNotEmpty)
                                Container(
                                  height: 120,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AppCachedImage(
                                      imageUrl: imageController.text.trim(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                              // Gallery Images Section
                               Text(
                                context.tr.photosAndGallery,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: newGalleryImageController,
                                      decoration: InputDecoration(
                                        hintText: context.tr.addGalleryImageHint,
                                        hintStyle: const TextStyle(fontSize: 12),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      final url =
                                          newGalleryImageController.text.trim();
                                      if (url.isNotEmpty &&
                                          !galleryImages.contains(url)) {
                                        setDialogState(() {
                                          galleryImages.add(url);
                                          newGalleryImageController.clear();
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.add_photo_alternate_rounded,
                                        size: 16),
                                    label: Text(context.tr.add),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              if (galleryImages.isNotEmpty)
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: galleryImages.length,
                                    itemBuilder: (context, idx) {
                                      final imgUrl = galleryImages[idx];
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(
                                                right: 8, top: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors.border),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: AppCachedImage(
                                                imageUrl: imgUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setDialogState(() {
                                                  galleryImages.removeAt(idx);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              else
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    context.tr.noGalleryImagesYet,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ============= Pinned Footer Actions =============
                    const Divider(height: 1, color: AppColors.border),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: const BorderSide(color: AppColors.border),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                context.tr.cancel,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState?.validate() ?? false) {
                                  final double parsedRating = double.tryParse(
                                          ratingController.text.trim()) ??
                                      4.5;
                                  final double parsedLat = double.tryParse(
                                          latController.text.trim()) ??
                                      33.5130;
                                  final double parsedLng = double.tryParse(
                                          lngController.text.trim()) ??
                                      36.3080;

                                  final mainImg = imageController.text.trim();
                                  final finalImages =
                                      List<String>.from(galleryImages);
                                  if (mainImg.isNotEmpty &&
                                      !finalImages.contains(mainImg)) {
                                    finalImages.insert(0, mainImg);
                                  }

                                  final newPlace = Place(
                                    id: isEditing
                                        ? placeToEdit.id
                                        : 'p_${DateTime.now().millisecondsSinceEpoch}',
                                    name: nameController.text.trim(),
                                    nameEn: nameEnController.text.trim(),
                                    category: selectedCat,
                                    categoryEn: selectedCatEn,
                                    location: locationController.text.trim(),
                                    image: mainImg,
                                    price: priceController.text.trim().isNotEmpty
                                        ? priceController.text.trim()
                                        : context.tr.moderate,
                                    description: descController.text.trim(),
                                    rating: parsedRating,
                                    reviews:
                                        isEditing ? placeToEdit.reviews : 1,
                                    images: finalImages.isNotEmpty
                                        ? finalImages
                                        : [mainImg],
                                    phone: phoneController.text.trim(),
                                    openingHours:
                                        openingHoursController.text.trim(),
                                    website: websiteController.text.trim(),
                                    latitude: parsedLat,
                                    longitude: parsedLng,
                                  );

                                  await _repository.savePlace(newPlace);
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
                                  _loadData();
                                  if (mounted) {
                                    AppSnackBar.showSuccess(
                                      context,
                                      isEditing
                                          ? context.tr.placeUpdatedSuccess
                                          : context.tr.placeAddedSuccess,
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isEditing ? context.tr.saveEdits : context.tr.addPlace,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmDialog(Place place) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.tr.deletePlaceTitle,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          content: Text(
            '${context.tr.deletePlaceConfirm} "${place.name}"?',
            style: GoogleFonts.cairo(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                context.tr.undo,
                style: GoogleFonts.cairo(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _repository.deletePlace(place.id);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                _loadData();
                if (mounted) {
                  AppSnackBar.showSuccess(context, context.tr.placeDeleted);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.tr.permanentDelete,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _places.where((place) {
      final matchesSearch = _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.nameEn.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'الكل' || place.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.tr.managePlacesTitle,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: context.tr.refresh,
            onPressed: _loadData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPlaceDialog(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(
          context.tr.addPlace,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ============= Search Bar =============
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              cursorColor: AppColors.primary,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: context.tr.searchByNameOrCity,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ============= Category Filter Chips =============
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 1 + _categories.length,
              itemBuilder: (context, index) {
                final rawCatName =
                    index == 0 ? 'الكل' : _categories[index - 1].name;
                final displayCatName =
                    index == 0 ? context.tr.all : _categories[index - 1].name;
                final isSelected = rawCatName == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(
                      displayCatName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = rawCatName;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // ============= Count & Header =============
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.tr.resultsCount}${filteredPlaces.length}',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_searchQuery.isNotEmpty || _selectedCategory != 'الكل')
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _selectedCategory = 'الكل';
                      });
                    },
                    child: Text(context.tr.resetFilter,
                        style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),

          // ============= Places List =============
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredPlaces.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 64, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              context.tr.noMatchingPlaces,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: filteredPlaces.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final place = filteredPlaces[index];
                          return _buildPlaceCard(place);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaceDetailScreen(place: place.toMap()),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: AppCachedImage(
                        imageUrl: place.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                place.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.secondaryDark,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${place.rating}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                place.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '📍 ${place.location}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${context.tr.ticketPrice}: ${place.price.isNotEmpty ? place.price : context.tr.moderate}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            if (place.images.length > 1) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• 📸 ${place.images.length} ${context.tr.photosAndGallery}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (place.openingHours.isNotEmpty || place.phone.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (place.openingHours.isNotEmpty) ...[
                                const Icon(Icons.access_time_rounded,
                                    size: 12, color: AppColors.textMuted),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    place.openingHours,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ),
                              ],
                              if (place.phone.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.phone_rounded,
                                    size: 12, color: AppColors.textMuted),
                                const SizedBox(width: 3),
                                Text(
                                  place.phone,
                                  style: const TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // ============= CMS Actions Row =============
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showPlaceDialog(placeToEdit: place),
                  icon: const Icon(Icons.edit_rounded,
                      size: 16, color: AppColors.primary),
                  label: Text(
                    context.tr.edit,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showDeleteConfirmDialog(place),
                  icon: Icon(Icons.delete_outline_rounded,
                      size: 16, color: Colors.red[600]),
                  label: Text(
                    context.tr.delete,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
