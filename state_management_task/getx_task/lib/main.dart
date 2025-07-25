import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controllers/Calc_Controllers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Calculator',
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalcController());
    final TextEditingController num1Controller = TextEditingController();
    final TextEditingController num2Controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter first number'),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter second number'),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.setAdd(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.setSub(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.setMul(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('*'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.setDiv(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('/'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.setMod(
                      int.parse(num1Controller.text),
                      int.parse(num2Controller.text),
                    );
                  },
                  child: const Text('%'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.clear();
                    num1Controller.clear();
                    num2Controller.clear();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              'Result: ${controller.result.value}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }
}
