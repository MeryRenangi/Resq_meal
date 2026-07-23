import 'package:resq_meal/models/models.dart';

/// Helper to generate mock domain objects and mock backend services for testing.
class MockTestData {
  static UserModel createTestUser({
    String id = 'user_001',
    String email = 'donor@resqmeal.com',
    String displayName = 'Test Donor',
    UserRole role = UserRole.donor,
    String? phone = '+1234567890',
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      role: role,
      phone: phone,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  static DonationModel createTestDonation({
    String id = 'don_001',
    String title = 'Fresh Organic Vegetables',
    String description = 'Surplus 10kg tomatoes and carrots from local garden.',
    int quantity = 10,
    String donorId = 'user_001',
    DonationStatus status = DonationStatus.available,
  }) {
    return DonationModel(
      id: id,
      title: title,
      description: description,
      quantity: quantity,
      unit: 'kg',
      category: FoodCategory.produce,
      donorId: donorId,
      donorName: 'Test Donor',
      status: status,
      createdAt: DateTime(2026, 1, 15),
      expiryAt: DateTime(2026, 1, 20),
    );
  }

  static FoodRequestModel createTestFoodRequest({
    String id = 'req_001',
    String ngoId = 'ngo_101',
    String ngoName = 'Hope Foundation',
    String title = 'Cooked Meals for Shelter',
    int requestedQuantity = 50,
    FoodRequestStatus status = FoodRequestStatus.pending,
  }) {
    return FoodRequestModel(
      id: id,
      ngoId: ngoId,
      ngoName: ngoName,
      title: title,
      description: 'Cooked meals needed for city shelter',
      quantityNeeded: requestedQuantity,
      status: status,
      createdAt: DateTime(2026, 1, 16),
    );
  }

  static NgoModel createTestNgo({
    String id = 'ngo_101',
    String userId = 'user_ngo_101',
    String name = 'Hope Foundation',
    String registrationNumber = 'REG-NGO-998877',
    NgoVerificationStatus status = NgoVerificationStatus.verified,
  }) {
    return NgoModel(
      id: id,
      userId: userId,
      organizationName: name,
      registrationNumber: registrationNumber,
      verificationStatus: status,
      contactPhone: '+1987654321',
      contactEmail: 'contact@hopefoundation.org',
    );
  }

  static QrVerificationModel createTestQrCode({
    String id = 'qr_5501',
    String donationId = 'don_001',
    String code = 'RESQ-QR-8899',
    bool isUsed = false,
  }) {
    return QrVerificationModel(
      id: id,
      donationId: donationId,
      code: code,
      type: QrVerificationType.pickup,
      verifiedByUserId: 'user_001',
      isUsed: isUsed,
      createdAt: DateTime(2026, 1, 15),
    );
  }

  static PaymentModel createTestPayment({
    String id = 'pay_301',
    double amount = 25.0,
    PaymentStatus status = PaymentStatus.completed,
  }) {
    return PaymentModel(
      id: id,
      userId: 'user_001',
      amount: amount,
      currency: 'USD',
      status: status,
      createdAt: DateTime(2026, 1, 15),
    );
  }
}

/// Fake In-Memory Auth Service for testing
class MockAuthService {
  bool isAuthenticated = false;
  UserModel? currentUser;
  final List<String> authLogs = [];

  Future<UserModel> login(String email, String password) async {
    authLogs.add('login:$email');
    if (email.contains('invalid') || password.length < 6) {
      throw Exception('Invalid email or password credentials');
    }
    isAuthenticated = true;
    currentUser = MockTestData.createTestUser(
      email: email,
      role: email.contains('ngo') ? UserRole.ngo : UserRole.donor,
    );
    return currentUser!;
  }

  Future<void> logout() async {
    authLogs.add('logout');
    isAuthenticated = false;
    currentUser = null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!email.contains('@')) throw Exception('Invalid email format');
    authLogs.add('reset:$email');
  }
}
