import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_task/providers/calc_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Calc_Provider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Calc_Provider>(context);
    final num1Controller = TextEditingController();
    final num2Controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator App',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter First Number'),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Second Number'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    provider.setAdd(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setSub(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setMul(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('*'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setDiv(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('/'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setMod(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('%'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setClear();
                    num1Controller.clear();
                    num2Controller.clear();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Result: ${provider.res}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
