import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/providers/libro_provider.dart';

class CustomListTile extends StatelessWidget {
  final Widget fotoPortada;
  final String libroTitulo;
  final String autor;
  final String estado;
  final int paginasLeidas;
  final int paginasTotales;
  final BuildContext contexto;
  final String direccion;
  final String id;
  CustomListTile({
    super.key,
    required this.fotoPortada, 
    required this.libroTitulo, 
    required this.autor,
    required this.estado, 
    required this.paginasLeidas, 
    required this.paginasTotales,
    required this.contexto,
    required this.direccion,
    required this.id
  });

  final libroprovider = LibroProvider();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: fotoPortada,
      title: Text(libroTitulo),
      subtitle: Text("$autor • $estado"),

      trailing: Text("$paginasLeidas/$paginasTotales"),
      onTap: (){
        print(id);
        contexto.pushNamed(
          direccion,
          extra: id
        );
        libroprovider.getLibrosStream();
      }
    );
  }
}