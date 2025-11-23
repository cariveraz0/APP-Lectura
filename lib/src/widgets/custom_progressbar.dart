import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomProgressbar extends StatelessWidget {
  final int leido;
  final int total;
  const CustomProgressbar({super.key, required this.leido, required this.total});

  @override
  Widget build(BuildContext context) {
    print('Libros totales: $leido');
    print('Libros leidos $total');
    final double porcentaje = double.parse(leido.toString()) / double.parse(total.toString());
    return Container(
      height: 50,
      color: const Color(0xFFA3B18A),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearPercentIndicator(
            width: 200,
            lineHeight: 20,
            percent: porcentaje,
            backgroundColor: const Color(0xFFDAD7CD),
            progressColor: const Color(0xFF3A5A40),
            barRadius: const Radius.circular(10),
            animation: true,
            animationDuration: 800,
            center: Text(
              "Pordentaje de lectura: ${(porcentaje * 100).toInt()}%",
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
    );
  }
}