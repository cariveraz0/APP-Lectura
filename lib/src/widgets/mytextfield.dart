import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextfield extends StatefulWidget{
  MyTextfield({
    super.key, 
    required this.type, 
    required this.obscuretext, 
    this.textoejemplo = '', 
    this.icono,
    this.controller,
    required this.texto,
    required this.tamaniotexto,
    required this.pmargin,
    required this.ppadding,
    required this.radio,
    required this.color
    });

  final TextInputType type;
  bool obscuretext;
  final String textoejemplo;
  final Widget? icono;
  final TextEditingController? controller;
  final String texto;
  final double tamaniotexto;
  final EdgeInsetsGeometry pmargin;
  final EdgeInsetsGeometry ppadding;
  final double radio;
  final Color color;
          

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late bool _isObscured;
  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscuretext; 
  }
  
  @override
  Widget build(BuildContext context){
    return Container(
      margin: widget.pmargin,
      padding: widget.ppadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radio),
        color: widget.color
      ),
      child: Column(
        children: [
          Text(
            widget.texto, 
            style: TextStyle(fontSize: widget.tamaniotexto),
          ),
          TextField(
            keyboardType: widget.type,
            obscureText: _isObscured,
            decoration: InputDecoration(
              label: Text(widget.textoejemplo),
              suffixIcon: widget.obscuretext
                ? IconButton(
                   icon : Icon(
                    _isObscured 
                    ? Icons.remove_red_eye_rounded 
                    : Icons.visibility_off_rounded
                  ), 
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
                : widget.icono,
            ),
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}