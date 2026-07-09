import 'package:flutter/foundation.dart';
import 'package:resq_meal/models/activity_item_model.dart';
import 'package:resq_meal/models/donation_model.dart';
import 'package:resq_meal/models/food_request_model.dart';
import 'package:resq_meal/models/notification_model.dart';
import 'package:resq_meal/services/activity_service.dart';

class ActivityProvider extends ChangeNotifier {
  ActivityProvider(this._service);

  final ActivityService _service;

  List<ActivityItemModel> _items = [];
  bool _isLoading = false;

  List<ActivityItemModel> get items => _items;
  bool get isLoading => _isLoading;

  void load({
    List<DonationModel> donations = const [],
    List<FoodRequestModel> requests = const [],
    List<NotificationModel> notifications = const [],
  }) {
    _isLoading = true;
    notifyListeners();
    _items = _service.buildFromSnapshots(
      donations: donations,
      requests: requests,
      notifications: notifications,
    );
    _isLoading = false;
    notifyListeners();
  }
}
