import 'package:flutter/material.dart';


class Addbook extends StatefulWidget {
const Addbook({super.key});


@override
State<Addbook> createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
final TextEditingController nombreController = TextEditingController();
final TextEditingController autorController = TextEditingController();
final TextEditingController totpagController = TextEditingController();
final TextEditingController pagleidasController = TextEditingController();
final TextEditingController imageUrlController = TextEditingController();


String estado = 'Pendiente';

  @override
  Widget build(BuildContext context) {
    
    throw UnimplementedError();
  }
}