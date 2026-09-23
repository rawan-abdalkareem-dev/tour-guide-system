import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_snack_bar.dart';
import '../../data/repositories/places_repository.dart';
import '../../models/category.dart';

/// Admin CMS Screen for managing tourist guide categories
class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  final PlacesRepository _repository = const PlacesRepository();
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _isLoading = true;
    });
    final list = _repository.getCategories();
    setState(() {
      _categories = list;
      _isLoading = false;
    });
  }

  Future<void> _showCategoryDialog({Category? categoryToEdit}) async {
    final isEditing = categoryToEdit != null;
    final nameController =
        TextEditingController(text: categoryToEdit?.name ?? '');
    final nameEnController =
        TextEditingController(text: categoryToEdit?.nameEn ?? '');
    final emojiController =
        TextEditingController(text: categoryToEdit?.emoji ?? '📍');
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isEditing ? context.tr.edit : context.tr.adminCategories,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: context.tr.name,
                      hintText: 'e.g. أسواق شعبية',
                      labelStyle: GoogleFonts.cairo(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? context.tr.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameEnController,
                    decoration: InputDecoration(
                      labelText: '${context.tr.name} (English)',
                      hintText: 'e.g. Traditional Souks',
                      labelStyle: GoogleFonts.cairo(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emojiController,
                    decoration: InputDecoration(
                      labelText: 'Emoji*',
                      hintText: 'e.g. 🛍️',
                      labelStyle: GoogleFonts.cairo(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? context.tr.fieldRequired
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                context.tr.cancel,
                style: GoogleFonts.cairo(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final newCat = Category(
                    id: isEditing
                        ? categoryToEdit.id
                        : 'c_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    nameEn: nameEnController.text.trim(),
                    emoji: emojiController.text.trim(),
                    count: isEditing ? categoryToEdit.count : 0,
                  );

                  await _repository.saveCategory(newCat);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _loadCategories();
                  if (mounted) {
                    AppSnackBar.showSuccess(
                      context,
                      context.tr.success,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isEditing ? context.tr.save : context.tr.confirm,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmDialog(Category category) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.tr.delete,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          content: Text(
            '${context.tr.delete} "${category.name}"?',
            style: GoogleFonts.cairo(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                context.tr.cancel,
                style: GoogleFonts.cairo(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _repository.deleteCategory(category.id);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                _loadCategories();
                if (mounted) {
                  AppSnackBar.showSuccess(context, context.tr.success);
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
                context.tr.delete,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.tr.adminCategories,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: context.tr.retry,
            onPressed: _loadCategories,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          context.tr.categories,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? Center(
                  child: Text(
                    context.tr.noPlacesFound,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.name,
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (cat.nameEn.isNotEmpty)
                                  Text(
                                    cat.nameEn,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${cat.count} ${context.tr.placesAndRestaurants}',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            tooltip: context.tr.edit,
                            onPressed: () =>
                                _showCategoryDialog(categoryToEdit: cat),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 20,
                              color: Colors.red[400],
                            ),
                            tooltip: context.tr.delete,
                            onPressed: () => _showDeleteConfirmDialog(cat),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
