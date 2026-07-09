import 'package:resq_meal/core/repository_exception.dart';
import 'package:resq_meal/models/user_model.dart';
import 'package:resq_meal/models/user_role.dart';
import 'package:resq_meal/repositories/user_repository.dart';

class UserManagementService {
  UserManagementService(this._repository);

  final UserRepository _repository;

  Future<UserModel?> getUser(String id) => _repository.getById(id);

  Stream<UserModel?> watchUser(String id) => _repository.watchById(id);

  Stream<List<UserModel>> watchUsersByRole(UserRole role) => _repository.watchByRole(role);

  Future<List<UserModel>> getAllUsers({int limit = 50}) => _repository.getAll(limit: limit);

  Future<String> createUser(UserModel user) async {
    if (user.email.isEmpty) throw RepositoryException('Email is required');
    return _repository.create(user, id: user.id);
  }

  Future<void> updateUser(UserModel user) => _repository.update(user.id, user);

  Future<void> deleteUser(String id) => _repository.delete(id);

  Future<void> deactivateUser(String id) =>
      _repository.updateFields(id, {'isActive': false});

  Future<List<UserModel>> searchUsers(String query) => _repository.searchByEmailPrefix(query);
}
