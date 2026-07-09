import 'package:flutter/material.dart';
import 'package:resq_meal/screens/requests/requests_tab.dart';

/// NGO request management — full-screen wrapper around requests list.
class NgoRequestsScreen extends StatelessWidget {
  const NgoRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request management')),
      body: const RequestsTab(),
    );
  }
}
