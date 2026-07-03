import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _imageController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _required(String? v, String label, AppLocalizations l) =>
      (v == null || v.trim().isEmpty) ? l.fieldRequired(label) : null;

  Future<void> _saveUser() async {
    final l = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      phone: _phoneController.text.trim(),
      image: _imageController.text.trim(),
      points: 0, // Yeni üye 0 puan ile başlar
      note: _noteController.text.trim(),
    );

    final success = await context.read<UserProvider>().addUser(newUser);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.registerSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.phoneAlreadyRegistered),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.newUser), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '${l.firstName} *'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => _required(v, l.firstName, l),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: '${l.lastName} *'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => _required(v, l.lastName, l),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: '${l.phone} *'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (v) {
                    final phone = v?.trim() ?? '';
                    if (phone.isEmpty) return l.phoneRequired;
                    if (phone.length < 10) return l.phoneMinLength;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: l.photoUrlOptional),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l.noteOptional),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveUser,
                  child: Text(l.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
