import 'package:resq_meal/models/payment_model.dart';
import 'package:resq_meal/repositories/payment_repository.dart';

class PaymentService {
  PaymentService(this._repository);

  final PaymentRepository _repository;

  Stream<List<PaymentModel>> watchUserPayments(String userId) =>
      _repository.watchByUser(userId);

  Stream<List<PaymentModel>> watchAllPayments() => _repository.watchAll();

  Future<PaymentModel?> getPayment(String id) => _repository.getById(id);
}
