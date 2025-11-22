import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lectura_app/src/widgets/custom_button.dart';
import 'package:lectura_app/src/widgets/custom_drawer.dart';
import 'package:lectura_app/src/widgets/custom_timer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LibroPage extends StatefulWidget {
  final String libroid;

  const LibroPage({super.key, required this.libroid});

  @override
  State<LibroPage> createState() => _LibroPageState();
  
}

class _LibroPageState extends State<LibroPage> {
  final TextEditingController pageController = TextEditingController();

  Future <void> actualizarPaginas(int nuevaPagina) async {
    final ref = FirebaseFirestore.instance.collection('libros').doc(widget.libroid);

    await ref.update({
      'paginasLeidas': nuevaPagina
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Estas en LibroPage()');
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('libros')
          .doc(widget.libroid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Libro no encontrado')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final titulo = data['titulo'];
        final autor = data['autor'];
        final portada = data['imagenPortada'];
        final paginasLeidas = data['paginasLeidas'];
        final paginasTotales = data['paginasTotales'];

        final progreso = paginasLeidas / paginasTotales;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(titulo, 
            style: TextStyle(fontWeight: FontWeight.bold),),
            centerTitle: true,
          ),

          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(portada, height: 100),
                ),
                const SizedBox(height: 20),
                Text(
                  autor,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "StackSansHeadline",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Páginas: $paginasLeidas / $paginasTotales',
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "StackSansHeadline",
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 15),

                const CustomTimer(),

                const SizedBox(height: 20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Última página leida:',
                      //textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "StackSansHeadline",
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      width: 169,
                      height: 45,
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ingrese la página',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),
                CustomButton(
                  text: "Guardar",
                  onPressed: () async {
                    if (pageController.text.isEmpty){
                      return;
                    }
                    final nuevaPagina = int.tryParse(pageController.text);

                    if (nuevaPagina == null){
                      return;
                    }

                    if (nuevaPagina > paginasTotales){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No se puede ingresar más páginas que el total del libro.'),
                        )
                      );
                      return;
                    }
                    await actualizarPaginas(nuevaPagina);

                    pageController.clear();
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            color: const Color(0xFFA3B18A),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  width: 200,
                  lineHeight: 20,
                  percent: progreso,
                  backgroundColor: const Color(0xFFDAD7CD),
                  progressColor: const Color(0xFF3A5A40),
                  barRadius: const Radius.circular(10),
                  animation: true,
                  animationDuration: 800,
                  center: Text(
                    "${(progreso * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: "StackSansHeadline",
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


