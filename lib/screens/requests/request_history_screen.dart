import 'package:flutter/material.dart';
import 'package:resq_meal/screens/requests/requests_tab.dart';

class RequestHistoryScreen extends StatelessWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request history')),
      body: const RequestsTab(),
    );
  }
}
