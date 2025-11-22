import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lectura_app/src/models/datos_libros.dart';

class LibroProvider {
  Stream<List<Libro>> getLibrosStream() {
    return FirebaseFirestore.instance
      .collection('libros')
      //.where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Libro.fromJson(doc.data(), id: doc.id);
        }).toList();
      });
  }
}