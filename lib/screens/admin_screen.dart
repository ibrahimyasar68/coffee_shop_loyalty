import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/utils/security.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Admin PIN'ini değiştir — mevcut PIN doğrulanmadan yenisi kabul edilmez.
  Future<void> _changePin() async {
    final l = AppLocalizations.of(context);
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        String? error;
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            Widget pinField(TextEditingController c, String label) => TextField(
                  controller: c,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration:
                      InputDecoration(labelText: label, counterText: ''),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );

            return AlertDialog(
              title: Text(l.changePin),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  pinField(currentCtrl, l.currentPin),
                  const SizedBox(height: 8),
                  pinField(newCtrl, l.newPin4),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(error!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(88, 40)),
                  onPressed: () {
                    if (!AdminSecurity.verifyPin(currentCtrl.text.trim())) {
                      setLocal(() => error = l.currentPinWrong);
                      return;
                    }
                    if (newCtrl.text.trim().length != 4) {
                      setLocal(() => error = l.newPin4Error);
                      return;
                    }
                    AdminSecurity.setPin(newCtrl.text.trim());
                    Navigator.pop(ctx, true);
                  },
                  child: Text(l.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.pinUpdated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final products = context.watch<ProductProvider>().items;
    final users = context.watch<UserProvider>().allUsers;
    final totalRevenue = products.fold(0.0, (s, p) => s + p.price);
    final totalPoints = users.fold(0, (s, u) => s + u.points);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.headerGradient),
        ),
        title: Text(
          l.adminPanel,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.password_rounded),
            tooltip: l.changePin,
            onPressed: _changePin,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.caramel,
          indicatorWeight: 3,
          labelColor: AppColors.caramel,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: l.tabSummary),
            Tab(text: l.tabProducts),
            Tab(text: l.tabMembers),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── ÖZET SEKMESİ ──────────────────────────────────
          _SummaryTab(
            productCount: products.length,
            userCount: users.length,
            totalRevenue: totalRevenue,
            totalPoints: totalPoints,
            products: products,
            users: users,
          ),

          // ── ÜRÜNLER SEKMESİ ───────────────────────────────
          _ProductsTab(products: products),

          // ── ÜYELER SEKMESİ ────────────────────────────────
          _UsersTab(users: users),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÖZET SEKMESİ
// ══════════════════════════════════════════════════════════════
class _SummaryTab extends StatelessWidget {
  final int productCount;
  final int userCount;
  final double totalRevenue;
  final int totalPoints;
  final List<Coffee> products;
  final List<User> users;

  const _SummaryTab({
    required this.productCount,
    required this.userCount,
    required this.totalRevenue,
    required this.totalPoints,
    required this.products,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // En yüksek puanlı 3 üye
    final topUsers = [...users]..sort((a, b) => b.points.compareTo(a.points));
    final top3 = topUsers.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İstatistik kartları
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.coffee,
                  label: l.statProducts,
                  value: productCount,
                  color: context.inkMedium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.people_outline,
                  label: l.statMembers,
                  value: userCount,
                  color: AppColors.mocha,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money,
                  label: l.statMenuTotal,
                  value: totalRevenue.round(),
                  suffix: ' TL',
                  color: context.inkStrong,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.star_outline,
                  label: l.statPointsGiven,
                  value: totalPoints,
                  suffix: ' P',
                  color: const Color(0xFFB8860B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // En yüksek puanlı üyeler
          Text(
            l.loyalCustomers,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.inkStrong,
            ),
          ),
          const SizedBox(height: 12),
          if (top3.isEmpty)
            _EmptyState(message: l.noMembersYet)
          else
            ...top3.asMap().entries.map((entry) {
              final i = entry.key;
              final user = entry.value;
              final medals = ['🥇', '🥈', '🥉'];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.espresso.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(medals[i], style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.name} ${user.surname}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.inkStrong,
                            ),
                          ),
                          Text(
                            user.phone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.caramel.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l.pointsShort(user.points),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.inkMedium,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 28),

          // Kategoriye göre ürün dağılımı
          Text(
            l.productsByCategory,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.inkStrong,
            ),
          ),
          const SizedBox(height: 12),
          ...(() {
            final Map<String, int> cats = {};
            for (final p in products) {
              cats[p.category] = (cats[p.category] ?? 0) + 1;
            }
            return cats.entries.map((e) => _CategoryBar(
                  category: e.key,
                  count: e.value,
                  total: products.length,
                ));
          })(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜRÜNLER SEKMESİ
// ══════════════════════════════════════════════════════════════
class _ProductsTab extends StatelessWidget {
  final List<Coffee> products;

  const _ProductsTab({required this.products});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        // Yeni ürün ekle butonu
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showAddProductSheet(context),
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: Text(
                l.newProduct,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.espresso,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),

        // Ürün listesi
        Expanded(
          child: products.isEmpty
              ? _EmptyState(message: l.noProductsYet)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final coffee = products[index];
                    return _ProductAdminCard(coffee: coffee);
                  },
                ),
        ),
      ],
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddProductSheet(),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜYELER SEKMESİ
// ══════════════════════════════════════════════════════════════
class _UsersTab extends StatelessWidget {
  final List<User> users;

  const _UsersTab({required this.users});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return users.isEmpty
        ? _EmptyState(message: l.noRegisteredMembers)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserAdminCard(user: user);
            },
          );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜRÜN KARTI (Admin)
// ══════════════════════════════════════════════════════════════
class _ProductAdminCard extends StatelessWidget {
  final Coffee coffee;

  const _ProductAdminCard({required this.coffee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: coffee.imagePath,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 52,
              height: 52,
              color: context.imagePlaceholder,
            ),
            errorWidget: (_, __, ___) => Container(
              width: 52,
              height: 52,
              color: AppColors.coffee,
              child: const Icon(Icons.coffee, color: Colors.white54, size: 22),
            ),
          ),
        ),
        title: Text(
          coffee.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.inkStrong,
            fontSize: 14,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${coffee.price.toStringAsFixed(0)} TL',
              style: TextStyle(
                  color: context.inkMedium, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.caramel.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '+${coffee.points}p',
                style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.mocha,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.mocha),
              onPressed: () => _showEditSheet(context, coffee),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(context, coffee),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, Coffee coffee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProductSheet(coffee: coffee),
    );
  }

  void _confirmDelete(BuildContext context, Coffee coffee) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            Text(l.deleteProduct, style: TextStyle(color: context.inkStrong)),
        content: Text(l.deleteConfirm(coffee.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel, style: const TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductProvider>().deleteProduct(coffee);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜYE KARTI (Admin)
// ══════════════════════════════════════════════════════════════
class _UserAdminCard extends StatelessWidget {
  final User user;

  const _UserAdminCard({required this.user});

  String _getBadge(int points, AppLocalizations l) {
    if (points >= 500) return l.badgeMaster;
    if (points >= 200) return l.badgeLover;
    if (points >= 50) return l.badgeRegular;
    return l.badgeNew;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.coffee, AppColors.espresso],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name} ${user.surname}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.inkStrong,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.phone.isNotEmpty ? user.phone : l.phoneNone,
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  _getBadge(user.points, l),
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.mocha),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.pointsShort(user.points),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.inkMedium,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _showEditSheet(context, user),
                    child: const Icon(Icons.edit_outlined,
                        color: AppColors.mocha, size: 20),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _confirmDelete(context, user),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditUserSheet(user: user),
    );
  }

  void _confirmDelete(BuildContext context, User user) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            Text(l.deleteMember, style: TextStyle(color: context.inkStrong)),
        content: Text(l.deleteConfirm('${user.name} ${user.surname}')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel, style: const TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserProvider>().deleteUser(user);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// YENİ ÜRÜN EKLE BOTTOM SHEET
// ══════════════════════════════════════════════════════════════
class _AddProductSheet extends StatefulWidget {
  const _AddProductSheet();

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _pointsController = TextEditingController();
  final _imageController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = kProductCategories.first;

  final List<String> _categories = kProductCategories;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _pointsController.dispose();
    _imageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final l = AppLocalizations.of(context);
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.nameAndPriceRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final coffee = Coffee(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      points: int.tryParse(_pointsController.text) ?? 0,
      category: _selectedCategory,
      imagePath: _imageController.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1509042239860-f550ce710b93'
          : _imageController.text.trim(),
      note: _noteController.text.trim(),
    );

    context.read<ProductProvider>().addProduct(coffee);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.productAdded(coffee.name)),
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.caramel,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.newProduct,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.inkStrong,
              ),
            ),
            const SizedBox(height: 16),

            _SheetField(controller: _nameController, label: '${l.productName} *'),
            _SheetField(
                controller: _priceController,
                label: '${l.priceTl} *',
                type: TextInputType.number),
            _SheetField(
                controller: _pointsController,
                label: l.points,
                type: TextInputType.number),
            _SheetField(
                controller: _imageController, label: l.imageUrlOptional),
            _SheetField(controller: _noteController, label: l.noteOptional),

            // Kategori seçimi
            const SizedBox(height: 8),
            Text(l.category,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : context.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : context.softBorder,
                        ),
                      ),
                      child: Text(
                        l.categoryLabel(cat),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : context.inkStrong,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l.save,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// YARDIMCI WİDGETLER
// ══════════════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value; // sayaç animasyonu için sayısal
  final String suffix; // ör. ' TL', ' P'
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCount(
                value: value,
                builder: (context, v) => Text('$v$suffix',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String category;
  final int count;
  final int total;

  const _CategoryBar({
    required this.category,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ratio = total > 0 ? count / total : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.categoryLabel(category),
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: context.inkStrong)),
              Text(l.productCount(count),
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: context.softFill,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.mocha),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 60, color: AppColors.caramel),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType type;

  const _SheetField({
    required this.controller,
    required this.label,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
          filled: true,
          fillColor: context.surfaceCard,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.softBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.softBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.mocha),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜRÜN DÜZENLEME BOTTOM SHEET
// ══════════════════════════════════════════════════════════════
class _EditProductSheet extends StatefulWidget {
  final Coffee coffee;
  const _EditProductSheet({required this.coffee});

  @override
  State<_EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<_EditProductSheet> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _pointsController;
  late TextEditingController _imageController;
  late TextEditingController _noteController;
  late String _selectedCategory;

  final List<String> _categories = kProductCategories;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coffee.name);
    _priceController =
        TextEditingController(text: widget.coffee.price.toStringAsFixed(0));
    _pointsController =
        TextEditingController(text: widget.coffee.points.toString());
    _imageController = TextEditingController(text: widget.coffee.imagePath);
    _noteController = TextEditingController(text: widget.coffee.note);
    _selectedCategory = widget.coffee.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _pointsController.dispose();
    _imageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final l = AppLocalizations.of(context);
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.nameAndPriceRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<ProductProvider>().updateProduct(
          widget.coffee,
          name: _nameController.text.trim(),
          price: double.tryParse(_priceController.text) ?? widget.coffee.price,
          points: int.tryParse(_pointsController.text) ?? widget.coffee.points,
          category: _selectedCategory,
          imagePath: _imageController.text.trim().isEmpty
              ? widget.coffee.imagePath
              : _imageController.text.trim(),
          note: _noteController.text.trim(),
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.nameUpdated(_nameController.text)),
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.caramel,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Başlık + önizleme
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.coffee.imagePath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 48,
                      height: 48,
                      color: context.imagePlaceholder,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: AppColors.coffee,
                      child: const Icon(Icons.coffee, color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l.editProduct,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.espresso,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SheetField(controller: _nameController, label: '${l.productName} *'),
            _SheetField(
                controller: _priceController,
                label: '${l.priceTl} *',
                type: TextInputType.number),
            _SheetField(
                controller: _pointsController,
                label: l.points,
                type: TextInputType.number),
            _SheetField(controller: _imageController, label: l.imageUrl),
            _SheetField(controller: _noteController, label: l.note),
            // Kategori
            Text(l.category,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : context.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : context.softBorder,
                        ),
                      ),
                      child: Text(
                        l.categoryLabel(cat),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : context.inkStrong,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l.update,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ÜYE DÜZENLEME BOTTOM SHEET
// ══════════════════════════════════════════════════════════════
class _EditUserSheet extends StatefulWidget {
  final User user;
  const _EditUserSheet({required this.user});

  @override
  State<_EditUserSheet> createState() => _EditUserSheetState();
}

class _EditUserSheetState extends State<_EditUserSheet> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _imageController;
  late TextEditingController _pointsController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _phoneController = TextEditingController(text: widget.user.phone);
    _imageController = TextEditingController(text: widget.user.image);
    _pointsController =
        TextEditingController(text: widget.user.points.toString());
    _noteController = TextEditingController(text: widget.user.note);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _imageController.dispose();
    _pointsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final l = AppLocalizations.of(context);
    if (_nameController.text.isEmpty || _surnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.nameSurnameRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    context.read<UserProvider>().updateUser(
          widget.user,
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          phone: _phoneController.text.trim(),
          image: _imageController.text.trim(),
          points: int.tryParse(_pointsController.text) ?? widget.user.points,
          note: _noteController.text.trim(),
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.nameUpdated(_nameController.text)),
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.caramel,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Başlık + avatar
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.coffee, AppColors.espresso],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      widget.user.name.isNotEmpty
                          ? widget.user.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.editMember,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.espresso,
                      ),
                    ),
                    Text(
                      '${widget.user.name} ${widget.user.surname}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SheetField(controller: _nameController, label: '${l.firstName} *'),
            _SheetField(
                controller: _surnameController, label: '${l.lastName} *'),
            _SheetField(
                controller: _phoneController,
                label: l.phone,
                type: TextInputType.phone),
            _SheetField(controller: _imageController, label: l.photoUrl),
            _SheetField(
                controller: _pointsController,
                label: l.points,
                type: TextInputType.number),
            _SheetField(controller: _noteController, label: l.note),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l.update,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
