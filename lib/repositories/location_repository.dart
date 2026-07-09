import 'package:resq_meal/models/location_model.dart';
import 'package:resq_meal/repositories/base_firestore_repository.dart';
import 'package:resq_meal/services/firebase_service.dart';

class LocationRepository extends BaseFirestoreRepository<LocationModel> {
  LocationRepository(FirebaseService firebase)
      : super(
          collection: firebase.locationsCollection,
          fromMap: adaptFromMap(LocationModel.fromMap),
          toMap: (l) => l.toMap(),
        );
}
