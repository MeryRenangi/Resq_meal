import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/services/backend_service_locator.dart';

/// Syncs FCM token and role topics after authentication.
class FcmTokenSync extends StatefulWidget {
  const FcmTokenSync({super.key, required this.child});

  final Widget child;

  @override
  State<FcmTokenSync> createState() => _FcmTokenSyncState();
}

class _FcmTokenSyncState extends State<FcmTokenSync> {
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final backend = context.watch<BackendServiceLocator?>();

    if (user != null && backend != null && user.id != _lastUserId) {
      _lastUserId = user.id;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await backend.fcm.persistTokenForUser(user.id);
        await backend.fcm.subscribeUserTopics(
          isDonor: user.role == UserRole.donor,
          isNgo: user.role == UserRole.ngo,
        );
      });
    } else if (user == null) {
      _lastUserId = null;
    }

    return widget.child;
  }
}
