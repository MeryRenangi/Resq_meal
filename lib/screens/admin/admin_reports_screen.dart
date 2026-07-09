import 'package:flutter/material.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Meals Rescued'),
              subtitle: Text('47 meals rescued this month'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.groups),
              title: Text('Active Users'),
              subtitle: Text('2 users registered'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.eco),
              title: Text('CO₂ Saved'),
              subtitle: Text('18.4 kg saved'),
            ),
          ),
        ],
      ),
    );
  }
}