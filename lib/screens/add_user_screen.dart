import 'package:coffee_shop_loyalty/models/user_model.dart';
import 'package:coffee_shop_loyalty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageController = TextEditingController();
  final _pointController = TextEditingController();
  final _noteController = TextEditingController();

  void saveUser() {
    if (_nameController.text.isEmpty || _surnameController.text.isEmpty) return;
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      surname: _surnameController.text,
      phone: _phoneController.text,
      image: _imageController.text,
      points: int.parse(_pointController.text),
      note: _noteController.text.isEmpty ? " " : _nameController.text,
    );
    context.read<UserProvider>().addUser(newUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Kayıt Oluşturma"), centerTitle: true),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Adı"),
                ),
              ),
              SizedBox(height: 12),

              Card(
                child: TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: "Soyadı"),
                ),
              ),
              SizedBox(height: 12),

              Card(
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Telefonu"),
                ),
              ),
              SizedBox(height: 12),

              Card(
                child: TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: "Resim"),
                ),
              ),
              SizedBox(height: 12),

              Card(
                child: TextField(
                  controller: _pointController,
                  decoration: InputDecoration(labelText: "Puanı"),
                ),
              ),
              SizedBox(height: 12),

              Card(
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: "Not"),
                ),
              ),
              SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 231, 174, 170),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    saveUser();
                  },
                  child: const Text(
                    "Kaydet",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
