import 'dart:async';

import 'package:flutter/material.dart';

class CountdownRace extends StatefulWidget {
  final DateTime fp1Start;
  final DateTime raceStart;

  const CountdownRace({
    super.key,
    required this.fp1Start,
    required this.raceStart,
  });

  @override
  State<CountdownRace> createState() => _CountdownRaceState();
}

class _CountdownRaceState extends State<CountdownRace> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTime.isBefore(widget.fp1Start)) {
      Duration diff = widget.fp1Start.difference(_currentTime);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimePart(diff.inDays.toString(), "Giorni"),
          _buildTimePart((diff.inHours % 24).toString(), "Ore"),
          _buildTimePart((diff.inMinutes % 60).toString(), "Min"),
          _buildTimePart((diff.inSeconds % 60).toString(), "Sec"),
        ],
      );
    }

    if (_currentTime.isBefore(widget.raceStart)) {
      return const Text(
          "Evento in corso!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
      );
    }

    DateTime raceExpirationWindow = widget.raceStart.add(const Duration(hours: 24));

    if (_currentTime.isBefore(raceExpirationWindow)) {
      return const Text(
          "Race Day!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTimePart(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}