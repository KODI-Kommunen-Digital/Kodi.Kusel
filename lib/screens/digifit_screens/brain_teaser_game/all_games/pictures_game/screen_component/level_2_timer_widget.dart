import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Level2TimerWidget extends StatefulWidget {
  final int seconds;

  const Level2TimerWidget({super.key, required this.seconds});

  @override
  State<Level2TimerWidget> createState() => _Level2TimerWidgetState();
}

class _Level2TimerWidgetState extends State<Level2TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 20,
            color: widget.seconds <= 10
                ? Colors.red
                : Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            _formatTime(widget.seconds),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.seconds <= 10 ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
