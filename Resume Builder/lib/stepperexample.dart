import 'package:flutter/material.dart';

class StepperExample extends StatefulWidget {
  const StepperExample({super.key});

  @override
  State<StepperExample> createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Stepper Example")),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 2) {
            setState(() => currentStep += 1);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All steps completed!")),
            );
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep -= 1);
          }
        },
        steps: const [
          Step(
            title: Text("Step 1"),
            content: Text("Enter your personal information"),
          ),
          Step(
            title: Text("Step 2"),
            content: Text("Enter your email address"),
          ),
          Step(
            title: Text("Step 3"),
            content: Text("Confirm and submit"),
          ),
        ],
      ),
    );
  }
}
