import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/l10n/l10n_helpers.dart';
import 'package:coffee_shop_loyalty/models/coffee_model.dart';
import 'package:coffee_shop_loyalty/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _pointsController = TextEditingController();
  final _imageController = TextEditingController();
  final _noteController = TextEditingController();

  String _category = kProductCategories.first;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _pointsController.dispose();
    _imageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Pozitif sayı doğrulayıcısı (fiyat için > 0, puan için >= 0)
  String? _validateNumber(String? value,
      {required bool allowZero, required AppLocalizations l}) {
    if (value == null || value.trim().isEmpty) return l.requiredField;
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) return l.enterValidNumber;
    if (parsed < 0) return l.cannotBeNegative;
    if (!allowZero && parsed == 0) return l.mustBePositive;
    return null;
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    final newCoffee = Coffee(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      price:
          double.parse(_priceController.text.trim().replaceAll(',', '.')),
      points: int.tryParse(_pointsController.text.trim()) ?? 0,
      category: _category,
      imagePath: _imageController.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1509042239860-f550ce710b93'
          : _imageController.text.trim(),
      note: _noteController.text.trim(),
    );

    context.read<ProductProvider>().addProduct(newCoffee);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.newProduct)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '${l.productName} *'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l.productNameRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: '${l.priceTl} *'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      _validateNumber(v, allowZero: false, l: l),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pointsController,
                  decoration: InputDecoration(labelText: '${l.points} *'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => _validateNumber(v, allowZero: true, l: l),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: InputDecoration(labelText: '${l.category} *'),
                  items: kProductCategories
                      .map((c) => DropdownMenuItem(
                          value: c, child: Text(l.categoryLabel(c))))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _category = v ?? kProductCategories.first),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageController,
                  decoration:
                      InputDecoration(labelText: l.imageUrlOptional),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l.noteOptional),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: Text(l.saveProduct),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
