import 'package:flutter/material.dart';
import 'package:resq_meal/models/activity_item_model.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/notification_model.dart';

/// Builds activity history from domain snapshots (no separate Firestore collection).
class ActivityService {
  List<ActivityItemModel> buildFromSnapshots({
    List<DonationModel> donations = const [],
    List<FoodRequestModel> requests = const [],
    List<NotificationModel> notifications = const [],
  }) {
    final items = <ActivityItemModel>[];

    for (final d in donations) {
      if (d.createdAt == null) continue;
      items.add(
        ActivityItemModel(
          id: 'donation_${d.id}',
          title: d.title,
          subtitle: 'Donation · ${d.status.name}',
          timestamp: d.createdAt!,
          type: 'donation',
          referenceId: d.id,
          icon: Icons.volunteer_activism_outlined,
        ),
      );
    }

    for (final r in requests) {
      if (r.createdAt == null) continue;
      items.add(
        ActivityItemModel(
          id: 'request_${r.id}',
          title: r.title,
          subtitle: 'Request · ${r.status.name}',
          timestamp: r.createdAt!,
          type: 'food_request',
          referenceId: r.id,
          icon: Icons.inbox_outlined,
        ),
      );
    }

    for (final n in notifications) {
      if (n.createdAt == null) continue;
      items.add(
        ActivityItemModel(
          id: 'notification_${n.id}',
          title: n.title,
          subtitle: n.body,
          timestamp: n.createdAt!,
          type: n.type.name,
          referenceId: n.referenceId,
          icon: Icons.notifications_outlined,
        ),
      );
    }

    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }
}
