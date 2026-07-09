import 'package:flutter/material.dart';
import 'package:resq_meal/screens/donations/donations_tab.dart';

/// Full-screen donation history for donors.
class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation history')),
      body: const DonationsTab(mode: DonationsTabMode.donorHistory),
    );
  }
}
