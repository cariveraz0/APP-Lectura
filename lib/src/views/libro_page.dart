import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/widgets/custom_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:percent_indicator/percent_indicator.dart';


class LibroPage extends StatefulWidget {
  const LibroPage({super.key});

  @override
  State<LibroPage> createState() => _LibroPageState();
}

class _LibroPageState extends State<LibroPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void dispose(){
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFA3B18A),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              context.go('/login');
            },
          ),
        title: Text('Libro XYZ'),
        
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 280),
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snapshot){
                final time = snapshot.data!;
                final display = StopWatchTimer.getDisplayTime(
                  time, milliSecond: false,
                );
                return Text(
                  display,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                );
              }
            ),

            SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: "Comenzar", 
                  onPressed: (){
                    _stopWatchTimer.onStartTimer();
                  }
                ),
                CustomButton(
                  text: "Detener", 
                  onPressed: (){
                    _stopWatchTimer.onStopTimer();
                  }
                ),
              ],
            ),
            
            SizedBox(height: 10),

            CustomButton(
              text: "Reiniciar", 
              onPressed: (){
               _stopWatchTimer.onResetTimer();
              }
            ),

            SizedBox(height: 80),

            CustomButton(
              text: "Guardar", 
              onPressed: (){
               
              }
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFFA3B18A),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearPercentIndicator(
              width: 200,
              lineHeight: 20,
              percent: 0.1,
              backgroundColor: Color(0xFFDAD7CD),
              progressColor: Color(0xFF3A5A40),
              barRadius: Radius.circular(10),
              animation: true,
              animationDuration: 800,
              center: Text(
                "${(0.1 * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.black, 
                  fontFamily: "StackSansHeadline",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
              ),
            ),
          ],
        )

          ),
        );
  }
  
}