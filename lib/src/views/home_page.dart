import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/models/datos_libros.dart';
import 'package:lectura_app/src/providers/libro_provider.dart';
import 'package:lectura_app/src/widgets/custom_drawer.dart';
import 'package:lectura_app/src/widgets/custom_listtile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final libroprovider = LibroProvider();

  @override
  Widget build(BuildContext context) {
    print('Estas en HomePage()');
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Libros')
        ),
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: libroprovider.getLibrosStream(), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final List<Libro> libros = snapshot.data!;

          return ListView.builder(
            itemCount: libros.length,
            itemBuilder: (BuildContext context, int index) {
              final libro = libros[index];
              
              return CustomListTile(
                fotoPortada: libro.imagenPortada.isNotEmpty
                  ? Image.network(libro.imagenPortada, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.book),
                libroTitulo: libro.titulo,
                autor: libro.autor,
                estado: libro.estado,
                paginasLeidas: libro.paginasLeidas,
                paginasTotales: libro.paginasTotales,
                contexto: context,
                direccion: 'libro',
                id: libro.id,
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print('Usuario: ${FirebaseAuth.instance.currentUser?.uid}'); // Para obtener el userid
        }
      ),
    );
  }
}