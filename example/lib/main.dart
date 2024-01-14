import 'package:flutter/material.dart';

void main() {
  runApp(const AppView());
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pixel Art Generator',
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art Generator'),
      ),
      body: const Center(
        child: Text('Generate Pixel Art'),
      ),
    );
  }
}
