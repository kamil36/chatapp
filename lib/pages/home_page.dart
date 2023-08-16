import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text("HomePage", style: TextStyle(fontWeight: FontWeight.bold),),
       centerTitle: true,
      backgroundColor: Colors.amber,
      ),
    );
  }
}