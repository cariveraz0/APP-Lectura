import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBookScreen extends StatefulWidget {
  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController totalPagesController = TextEditingController();
  TextEditingController readPagesController = TextEditingController();

  String status = "Pendiente";
  File? coverImage;

  // --- Seleccionar imagen desde galería ---
  Future<dynamic> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        coverImage = File(picked.path);
      });
    }
  }

  // --- Subir imagen a Firebase Storage ---
  Future<String?> uploadImage(String userId, String bookId) async {
    if (coverImage == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users/$userId/books/$bookId/cover.jpg');

    await storageRef.putFile(coverImage!);

    return await storageRef.getDownloadURL();
  }

  // --- Guardar libro en Firestore ---
  Future<void> saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String userId = user.uid;
      String bookId = FirebaseFirestore.instance.collection('tmp').doc().id;

      String? imageUrl = await uploadImage(userId, bookId);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("books")
          .doc(bookId)
          .set({
        "title": titleController.text,
        "author": authorController.text,
        "status": status,
        "totalPages": int.parse(totalPagesController.text),
        "readPages": int.parse(readPagesController.text),
        "coverUrl": imageUrl,
        "createdAt": DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Libro agregado correctamente")),
      );

      Navigator.pop(context);

    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar el libro")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Libro")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ---------- IMAGEN DE PORTADA ----------
              GestureDetector(
                onTap: pickImage,
                child: coverImage == null
                    ? Container(
                        height: 170,
                        width: 130,
                        color: Colors.grey[300],
                        child: Icon(Icons.add_photo_alternate, size: 40),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          coverImage!,
                          height: 170,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

              SizedBox(height: 25),

              // ---------- TÍTULO ----------
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Título"),
                validator: (v) =>
                    v!.isEmpty ? "Ingrese un título" : null,
              ),

              SizedBox(height: 15),

              // ---------- AUTOR ----------
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: "Autor"),
                validator: (v) =>
                    v!.isEmpty ? "Ingrese el autor" : null,
              ),

              SizedBox(height: 15),

              // ---------- ESTADO ----------
              DropdownButtonFormField<String>(
                value: status,
                items: [
                  "Pendiente",
                  "En progreso",
                  "Finalizado",
                ].map((s) =>
                    DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) {
                  setState(() => status = value!);
                },
                decoration: InputDecoration(labelText: "Estado"),
              ),

              SizedBox(height: 15),

              // ---------- PÁGINAS TOTALES ----------
              TextFormField(
                controller: totalPagesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Páginas totales"),
                validator: (v) =>
                    v!.isEmpty ? "Ingrese el número de páginas" : null,
              ),

              SizedBox(height: 15),

              // ---------- PÁGINAS LEÍDAS ----------
              TextFormField(
                controller: readPagesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Páginas leídas"),
                validator: (v) =>
                    v!.isEmpty ? "Ingrese las páginas leídas" : null,
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveBook,
                  child: Text("Guardar Libro"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  ImagePicker() {}
}

mixin ImagePicker {
}

class FirebaseStorage {
  static get instance => null;
}
