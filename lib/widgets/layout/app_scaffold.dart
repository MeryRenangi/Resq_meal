import 'package:flutter/material.dart';
import 'package:resq_meal/constants/app_constants.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = false,
    this.padding = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              automaticallyImplyLeading: showBackButton,
              actions: actions,
            )
          : null,
      body: padding
          ? Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: body,
            )
          : body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
