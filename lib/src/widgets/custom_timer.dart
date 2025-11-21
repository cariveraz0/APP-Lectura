import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'custom_button.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({super.key});

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: 0,
          builder: (context, snapshot) {
            final time = snapshot.data!;
            final display = StopWatchTimer.getDisplayTime(
              time,
              milliSecond: false,
            );
            return Text(
              display,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              text: "Comenzar",
              onPressed: () {
                _stopWatchTimer.onStartTimer();
              },
            ),
            CustomButton(
              text: "Detener",
              onPressed: () {
                _stopWatchTimer.onStopTimer();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: "Reiniciar",
          onPressed: () {
            _stopWatchTimer.onResetTimer();
          },
        ),
      ],
    );
  }
}
