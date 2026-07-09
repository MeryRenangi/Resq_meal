import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resq_meal/core/firestore_mapper.dart';
import 'package:resq_meal/core/repository_exception.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> map, String id);

/// Adapter for model factories that use a named `id` parameter.
FromMap<T> adaptFromMap<T>(T Function(Map<String, dynamic> map, {required String id}) factory) {
  return (map, id) => factory(map, id: id);
}
typedef ToMap<T> = Map<String, dynamic> Function(T item);

abstract class BaseFirestoreRepository<T> {
  BaseFirestoreRepository({
    required this.collection,
    required this.fromMap,
    required this.toMap,
  });

  final CollectionReference<Map<String, dynamic>> collection;
  final FromMap<T> fromMap;
  final ToMap<T> toMap;

  T _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw RepositoryException('Document ${doc.id} has no data');
    }
    return fromMap(data, doc.id);
  }

  Future<T?> getById(String id) async {
    final doc = await collection.doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  Stream<T?> watchById(String id) {
    return collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _fromDoc(doc);
    });
  }

  Future<List<T>> getAll({int limit = 50}) async {
    final snapshot = await collection.orderBy('createdAt', descending: true).limit(limit).get();
    return snapshot.docs.map(_fromDoc).toList();
  }

  Stream<List<T>> watchAll({int limit = 50}) {
    return collection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map(_fromDoc).toList());
  }

  Future<String> create(T item, {String? id}) async {
    final docRef = id != null ? collection.doc(id) : collection.doc();
    await docRef.set(FirestoreMapper.withTimestamps(data: toMap(item), isCreate: true));
    return docRef.id;
  }

  Future<void> update(String id, T item) async {
    await collection.doc(id).update(FirestoreMapper.withTimestamps(data: toMap(item)));
  }

  Future<void> updateFields(String id, Map<String, dynamic> fields) async {
    await collection.doc(id).update(FirestoreMapper.withTimestamps(data: fields));
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }
}
