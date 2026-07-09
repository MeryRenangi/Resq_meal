import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/feedback_model.dart';
import 'package:resq_meal/repositories/feedback_repository.dart';
import 'package:uuid/uuid.dart';

class FeedbackService {
  FeedbackService(this._repository);

  final FeedbackRepository _repository;
  final _uuid = const Uuid();

  Stream<List<FeedbackModel>> watchUserFeedback(String userId) =>
      _repository.watchByUser(userId);

  Stream<List<FeedbackModel>> watchAllFeedback() => _repository.watchAll();

  Future<String> submitFeedback({
    required String userId,
    required int rating,
    required String comment,
    String? referenceId,
    String? referenceType,
  }) async {
    if (rating < 1 || rating > 5) {
      throw RepositoryException('Rating must be between 1 and 5');
    }
    if (comment.trim().isEmpty) {
      throw RepositoryException('Comment is required');
    }
    final id = _uuid.v4();
    await _repository.create(
      FeedbackModel(
        id: id,
        userId: userId,
        rating: rating,
        comment: comment.trim(),
        referenceId: referenceId,
        referenceType: referenceType,
        createdAt: DateTime.now(),
      ),
      id: id,
    );
    return id;
  }
}
