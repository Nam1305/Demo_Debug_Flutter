import 'package:flutter/material.dart';
import 'package:demo_flutter_test/screens/detail_screen.dart';
import 'package:demo_flutter_test/widgets/counter_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CounterWidget(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              key: const Key('navigate_button'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DetailScreen(title: 'Chi tiết'),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Xem chi tiết'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
