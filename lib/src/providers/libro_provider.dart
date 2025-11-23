import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lectura_app/src/models/datos_libros.dart';

class LibroProvider {
  Stream<List<Libro>> getLibrosStream() {
    return FirebaseFirestore.instance
      .collection('libros')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Libro.fromJson(doc.data(), id: doc.id);
        }).toList();
      });
  }

  Future<void> guardarLibro(Map<String, dynamic> nuevolibro) async {
    final db = FirebaseFirestore.instance;
    final collectionRefTodos = db.collection('libros');
    await collectionRefTodos.add(nuevolibro);
  }

   Future<String?> subirimagen(String nombreimagen) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (pickedFile == null) {
        return null;
      }
      File file = File(pickedFile.path);

      final nombreArchivo = "${nombreimagen + DateTime.now().toString()}.jpg";
      final ref = FirebaseStorage.instance.ref().child(nombreArchivo);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } 
    catch (e)
    {
      return null;
    }
  }
}