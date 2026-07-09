import 'package:flutter/material.dart';
import 'package:resq_meal/app.dart';
import 'package:resq_meal/config/firebase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const ResQMealApp());
}
