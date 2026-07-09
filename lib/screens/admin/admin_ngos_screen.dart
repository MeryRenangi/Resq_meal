import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/providers/ngo_provider.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/utils/responsive.dart';
import 'package:resq_meal/widgets/common/empty_state.dart';

class AdminNgosScreen extends StatefulWidget {
  const AdminNgosScreen({super.key});

  @override
  State<AdminNgosScreen> createState() => _AdminNgosScreenState();
}

class _AdminNgosScreenState extends State<AdminNgosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NgoProvider>().watchPendingForAdmin();
      context.read<NgoProvider>().watchVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ngo = context.watch<NgoProvider>();
    final pending = ngo.pendingNgos;
    final verified = ngo.verifiedNgos;

    return Scaffold(
      appBar: AppBar(title: const Text('NGO management')),
      body: ListView(
        padding: Responsive.pagePadding(context),
        children: [
          Text('Pending verification', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (pending.isEmpty)
            const EmptyState(
              title: 'No pending NGOs',
              subtitle: 'All registrations are processed.',
              icon: Icons.verified_outlined,
            )
          else
            ...pending.map(
              (n) => Card(
                child: ListTile(
                  title: Text(n.organizationName),
                  subtitle: Text(n.contactEmail),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
                        onPressed: () => ngo.verify(n.id, n.userId, approved: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                        onPressed: () => ngo.verify(n.id, n.userId, approved: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text('Verified NGOs (${verified.length})', style: Theme.of(context).textTheme.titleLarge),
          ...verified.map(
            (n) => ListTile(
              title: Text(n.organizationName),
              subtitle: Text('${n.totalDonationsReceived} donations · ${n.totalMealsDistributed} meals'),
              trailing: const Icon(Icons.verified_rounded, color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
