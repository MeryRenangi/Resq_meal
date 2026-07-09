import 'package:flutter/material.dart';
import 'package:resq_meal/utils/responsive.dart';

/// Centers content with max width for tablet/desktop layouts.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.contentMaxWidth(context);
    final pad = padding ?? Responsive.pagePadding(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: pad, child: child),
      ),
    );
  }
}
