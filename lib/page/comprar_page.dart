import 'package:flutter/material.dart';

class ComprarPage extends StatefulWidget {
  const ComprarPage({super.key});

  @override
  State<ComprarPage> createState() => _ComprarPageState();
}

class _ComprarPageState extends State<ComprarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.maxFinite,
              color: Colors.amber,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                chartButton('\$20'),
                chartButton('\$50'),
                chartButton('\$100'),
                chartButton('MAX'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  chartButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.grey),
        ),
        child: Text(label),
      ),
    );
  }
}
