import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  void _increment() {
    setState(() => _count++);
  }

  void _decrement() {
    setState(() {
      if (_count > 0) _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Số đếm hiện tại:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          '$_count',
          key: const Key('counter_text'),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _decrement, child: const Text('-')),
            const SizedBox(width: 16),
            ElevatedButton(
              key: const Key('increment_button'),
              onPressed: _increment,
              child: const Text('+'),
            ),
          ],
        ),
      ],
    );
  }
}
