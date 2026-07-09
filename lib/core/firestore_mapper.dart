import 'package:cloud_firestore/cloud_firestore.dart';

abstract final class FirestoreMapper {
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static dynamic serializeDate(DateTime? value) {
    if (value == null) return null;
    return Timestamp.fromDate(value);
  }

  static Map<String, dynamic> withTimestamps({
    required Map<String, dynamic> data,
    bool isCreate = false,
  }) {
    final now = FieldValue.serverTimestamp();
    return {
      ...data,
      'updatedAt': now,
      if (isCreate) 'createdAt': now,
    };
  }
}
