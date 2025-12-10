import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Password")),
      body: const Center(
        child: Text(
          "Fitur lupa password belum tersedia.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
