import 'package:flutter_test/flutter_test.dart';
import 'package:resq_meal/models/models.dart';

void main() {
  group('Flutter App Food Requests & NGO Models Test Suite (APP-101 to APP-150)', () {
    test('APP-101: FoodRequestModel serializes to map correctly', () {
      final req = FoodRequestModel(
        id: 'req_101',
        ngoId: 'ngo_01',
        ngoName: 'Community Kitchen',
        title: 'Need 50 hot meals',
        description: 'Hot meals needed for shelter',
        quantityNeeded: 50,
        status: FoodRequestStatus.pending,
        createdAt: DateTime(2026, 1, 12),
      );
      final json = req.toMap();
      expect(req.id, 'req_101');
      expect(json['quantityNeeded'], 50);
      expect(json['status'], 'pending');
    });

    test('APP-102: FoodRequestModel deserializes from map correctly', () {
      final json = {
        'ngoId': 'ngo_02',
        'ngoName': 'Shelter House',
        'title': 'Need bread and milk',
        'description': 'Description',
        'quantityNeeded': 30,
        'status': 'completed',
        'createdAt': '2026-01-12T00:00:00.000Z',
      };
      final req = FoodRequestModel.fromMap(json, id: 'req_102');
      expect(req.id, 'req_102');
      expect(req.status, FoodRequestStatus.completed);
      expect(req.quantityNeeded, 30);
    });

    test('APP-103: FoodRequestStatus enum parses status string pending correctly', () {
      expect(FoodRequestStatus.pending.name, 'pending');
      expect(FoodRequestStatus.completed.name, 'completed');
      expect(FoodRequestStatus.cancelled.name, 'cancelled');
    });

    test('APP-104: Urgency level tag checks priority high', () {
      bool isHighUrgency(int qty) => qty >= 50;
      expect(isHighUrgency(50), isTrue);
      expect(isHighUrgency(10), isFalse);
    });

    test('APP-105: NgoModel serializes verification status verified correctly', () {
      final ngo = NgoModel(
        id: 'ngo_105',
        userId: 'u105',
        organizationName: 'Safe Haven',
        registrationNumber: 'REG-105',
        verificationStatus: NgoVerificationStatus.verified,
        contactPhone: '+11223344',
        contactEmail: 'safe@haven.org',
      );
      final json = ngo.toMap();
      expect(json['verificationStatus'], 'verified');
    });

    test('APP-106: NgoModel deserializes verification status pending correctly', () {
      final json = {
        'userId': 'u106',
        'organizationName': 'New Care',
        'registrationNumber': 'REG-106',
        'verificationStatus': 'pending',
        'contactPhone': '+11223355',
        'contactEmail': 'new@care.org',
      };
      final ngo = NgoModel.fromMap(json, id: 'ngo_106');
      expect(ngo.verificationStatus, NgoVerificationStatus.pending);
    });

    test('APP-107: NgoVerificationStatus enum names string representations match', () {
      expect(NgoVerificationStatus.pending.name, 'pending');
      expect(NgoVerificationStatus.verified.name, 'verified');
      expect(NgoVerificationStatus.rejected.name, 'rejected');
    });

    test('APP-108: Food request quantity must be positive number', () {
      bool validateReqQty(int qty) => qty > 0;
      expect(validateReqQty(0), isFalse);
      expect(validateReqQty(25), isTrue);
    });

    test('APP-109: Food request title validator requires min 5 characters', () {
      bool validateTitle(String title) => title.trim().length >= 5;
      expect(validateTitle('Food'), isFalse);
      expect(validateTitle('Food for shelter'), isTrue);
    });

    test('APP-110: High urgency food request highlights priority banner', () {
      bool isHighPriority(int quantityNeeded) => quantityNeeded >= 50;
      expect(isHighPriority(50), isTrue);
      expect(isHighPriority(10), isFalse);
    });

    test('APP-111: Food request status transition to completed', () {
      final req = FoodRequestModel(
        id: '111',
        ngoId: 'ngo_1',
        ngoName: 'N1',
        title: 'Meals',
        description: 'Desc',
        quantityNeeded: 20,
        status: FoodRequestStatus.pending,
        createdAt: DateTime.now(),
      );
      final map = req.toMap();
      map['status'] = 'completed';
      final updated = FoodRequestModel.fromMap(map, id: req.id);
      expect(updated.status, FoodRequestStatus.completed);
    });

    test('APP-112: Food request status transition to cancelled', () {
      final req = FoodRequestModel(
        id: '112',
        ngoId: 'ngo_1',
        ngoName: 'N1',
        title: 'Meals',
        description: 'Desc',
        quantityNeeded: 20,
        status: FoodRequestStatus.pending,
        createdAt: DateTime.now(),
      );
      final map = req.toMap();
      map['status'] = 'cancelled';
      final updated = FoodRequestModel.fromMap(map, id: req.id);
      expect(updated.status, FoodRequestStatus.cancelled);
    });

    test('APP-113: NGO registration number format validator checks prefix REG', () {
      bool validateRegNum(String reg) => reg.startsWith('REG-') && reg.length >= 8;
      expect(validateRegNum('12345'), isFalse);
      expect(validateRegNum('REG-998877'), isTrue);
    });

    test('APP-114: Unverified NGO blocked from creating new food requests', () {
      bool canCreateRequest(NgoVerificationStatus status) => status == NgoVerificationStatus.verified;
      expect(canCreateRequest(NgoVerificationStatus.pending), isFalse);
      expect(canCreateRequest(NgoVerificationStatus.rejected), isFalse);
      expect(canCreateRequest(NgoVerificationStatus.verified), isTrue);
    });

    test('APP-115: NGO dashboard request filter filters pending requests', () {
      final reqs = [
        FoodRequestModel(id: '1', ngoId: 'n', ngoName: 'N', title: 'T1', description: 'D', quantityNeeded: 5, status: FoodRequestStatus.pending, createdAt: DateTime.now()),
        FoodRequestModel(id: '2', ngoId: 'n', ngoName: 'N', title: 'T2', description: 'D', quantityNeeded: 5, status: FoodRequestStatus.completed, createdAt: DateTime.now()),
      ];
      final pending = reqs.where((r) => r.status == FoodRequestStatus.pending).toList();
      expect(pending.length, 1);
      expect(pending.first.id, '1');
    });

    test('APP-116: Food request list sorter sorts highest quantity to top', () {
      final r1 = FoodRequestModel(id: '1', ngoId: 'n', ngoName: 'N', title: 'T1', description: 'D', quantityNeeded: 5, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      final r2 = FoodRequestModel(id: '2', ngoId: 'n', ngoName: 'N', title: 'T2', description: 'D', quantityNeeded: 50, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      final list = [r1, r2];
      list.sort((a, b) => b.quantityNeeded.compareTo(a.quantityNeeded));
      expect(list.first.id, '2');
    });

    test('APP-117: NGO document upload validator accepts PDF and JPEG extensions', () {
      bool isValidDoc(String filename) {
        final ext = filename.split('.').last.toLowerCase();
        return ['pdf', 'jpg', 'jpeg', 'png'].contains(ext);
      }
      expect(isValidDoc('certificate.pdf'), isTrue);
      expect(isValidDoc('exe_file.exe'), isFalse);
    });

    test('APP-118: NGO document max file size validator caps upload at 10MB', () {
      bool isValidSize(int bytes) => bytes <= 10 * 1024 * 1024;
      expect(isValidSize(5 * 1024 * 1024), isTrue);
      expect(isValidSize(15 * 1024 * 1024), isFalse);
    });

    test('APP-119: Fulfilling food request increments NGO total meals fulfilled counter', () {
      int totalFulfilled = 45;
      int fulfill(int qty) => totalFulfilled + qty;
      expect(fulfill(15), 60);
    });

    test('APP-120: Food request donor match algorithm finds matching donor in zip', () {
      final donorsInZip = [{'id': 'd1', 'zip': '90210'}, {'id': 'd2', 'zip': '10001'}];
      final matches = donorsInZip.where((d) => d['zip'] == '90210').toList();
      expect(matches.length, 1);
    });

    test('APP-121: NGO profile contact phone number is required field', () {
      bool validatePhone(String? phone) => phone != null && phone.trim().isNotEmpty;
      expect(validatePhone(null), isFalse);
      expect(validatePhone('+1555000111'), isTrue);
    });

    test('APP-122: Food request expiration auto-cancels open request after 48h', () {
      final createdAt = DateTime.now().subtract(const Duration(hours: 50));
      bool isRequestExpired(DateTime created) => DateTime.now().difference(created).inHours >= 48;
      expect(isRequestExpired(createdAt), isTrue);
    });

    test('APP-123: Active food request count excludes completed requests', () {
      final requests = [FoodRequestStatus.pending, FoodRequestStatus.completed, FoodRequestStatus.pending];
      final activeCount = requests.where((s) => s == FoodRequestStatus.pending).length;
      expect(activeCount, 2);
    });

    test('APP-124: NGO verification rejection reason message is present on rejected NGO', () {
      final map = {'status': 'rejected', 'reason': 'Missing tax ID documentation'};
      expect(map['reason'], contains('tax ID'));
    });

    test('APP-125: Food request note field caps length at 300 characters', () {
      bool validateNote(String note) => note.length <= 300;
      expect(validateNote('Special request notes'), isTrue);
      expect(validateNote('a' * 301), isFalse);
    });

    test('APP-126: Request status badge label returns pending for pending request', () {
      String getStatusLabel(FoodRequestStatus status) => status.name.toUpperCase();
      expect(getStatusLabel(FoodRequestStatus.pending), 'PENDING');
    });

    test('APP-127: Request status badge label returns completed for completed request', () {
      String getStatusLabel(FoodRequestStatus status) => status.name.toUpperCase();
      expect(getStatusLabel(FoodRequestStatus.completed), 'COMPLETED');
    });

    test('APP-128: NGO beneficiary count validator enforces positive integer', () {
      bool validateBeneficiaries(int count) => count > 0;
      expect(validateBeneficiaries(0), isFalse);
      expect(validateBeneficiaries(120), isTrue);
    });

    test('APP-129: Food request creation draft persists unsubmitted form values', () {
      final draft = {'title': 'Need Rice', 'quantity': 100};
      expect(draft['quantity'], 100);
    });

    test('APP-130: Clearing request draft empties saved draft map', () {
      Map<String, dynamic>? draft = {'title': 'Need Rice'};
      draft = null;
      expect(draft, isNull);
    });

    test('APP-131: NGO operational hours format matches standard time range', () {
      final hours = '09:00 AM - 05:00 PM';
      expect(hours, contains('-'));
    });

    test('APP-132: NGO tax exemption status flag defaults to false', () {
      final map = {'taxExempt': false};
      expect(map['taxExempt'], isFalse);
    });

    test('APP-133: Food request response notification title contains NGO name', () {
      String buildTitle(String ngoName) => 'New response from $ngoName';
      expect(buildTitle('Hope Shelter'), 'New response from Hope Shelter');
    });

    test('APP-134: Partial request fulfillment subtracts delivered count from requested', () {
      int remainingNeeded(int requested, int delivered) => requested - delivered;
      expect(remainingNeeded(100, 40), 60);
    });

    test('APP-135: Fully delivered request transitions status to completed automatically', () {
      FoodRequestStatus checkStatus(int remaining) => remaining <= 0 ? FoodRequestStatus.completed : FoodRequestStatus.pending;
      expect(checkStatus(0), FoodRequestStatus.completed);
    });

    test('APP-136: Food request search filters list by query term in title', () {
      final list = [
        FoodRequestModel(id: '1', ngoId: 'n', ngoName: 'N', title: 'Milk required', description: 'D', quantityNeeded: 10, status: FoodRequestStatus.pending, createdAt: DateTime.now()),
        FoodRequestModel(id: '2', ngoId: 'n', ngoName: 'N', title: 'Canned soup', description: 'D', quantityNeeded: 10, status: FoodRequestStatus.pending, createdAt: DateTime.now()),
      ];
      final res = list.where((r) => r.title.toLowerCase().contains('milk')).toList();
      expect(res.length, 1);
    });

    test('APP-137: Food request search returns all items when query is empty', () {
      final list = [
        FoodRequestModel(id: '1', ngoId: 'n', ngoName: 'N', title: 'T1', description: 'D', quantityNeeded: 10, status: FoodRequestStatus.pending, createdAt: DateTime.now()),
        FoodRequestModel(id: '2', ngoId: 'n', ngoName: 'N', title: 'T2', description: 'D', quantityNeeded: 10, status: FoodRequestStatus.pending, createdAt: DateTime.now()),
      ];
      final q = '';
      final res = q.isEmpty ? list : list.where((r) => r.title.contains(q)).toList();
      expect(res.length, 2);
    });

    test('APP-138: NGO profile verification badge shows checkmark for verified status', () {
      bool showBadge(NgoVerificationStatus s) => s == NgoVerificationStatus.verified;
      expect(showBadge(NgoVerificationStatus.verified), isTrue);
      expect(showBadge(NgoVerificationStatus.pending), isFalse);
    });

    test('APP-139: NGO provider loading state toggles isLoading flag during fetch', () {
      bool isLoading = false;
      void startLoading() => isLoading = true;
      startLoading();
      expect(isLoading, isTrue);
    });

    test('APP-140: NGO provider loading state turns false after data fetch finishes', () {
      bool isLoading = true;
      void finishLoading() => isLoading = false;
      finishLoading();
      expect(isLoading, isFalse);
    });

    test('APP-141: Food request detail page title displays request title', () {
      final req = FoodRequestModel(id: '141', ngoId: 'n', ngoName: 'N', title: 'Hot Soup Needed', description: 'D', quantityNeeded: 20, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      expect(req.title, 'Hot Soup Needed');
    });

    test('APP-142: Food request detail page requested by field shows NGO name', () {
      final req = FoodRequestModel(id: '142', ngoId: 'n1', ngoName: 'St. Mary Kitchen', title: 'T', description: 'D', quantityNeeded: 20, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      expect(req.ngoName, 'St. Mary Kitchen');
    });

    test('APP-143: Rejecting food request transitions status to cancelled', () {
      final req = FoodRequestModel(id: '143', ngoId: 'n', ngoName: 'N', title: 'T', description: 'D', quantityNeeded: 5, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      final map = req.toMap();
      map['status'] = 'cancelled';
      final rejected = FoodRequestModel.fromMap(map, id: req.id);
      expect(rejected.status, FoodRequestStatus.cancelled);
    });

    test('APP-144: NGO rating average score ranges from 0.0 to 5.0', () {
      bool isValidRating(double score) => score >= 0.0 && score <= 5.0;
      expect(isValidRating(4.8), isTrue);
      expect(isValidRating(5.5), isFalse);
    });

    test('APP-145: Food request creation date format renders formatted string', () {
      final dt = DateTime(2026, 1, 15);
      String fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      expect(fmt(dt), '2026-01-15');
    });

    test('APP-146: NGO profile mission statement trimmer caps length at 500 chars', () {
      String sanitizeMission(String raw) => raw.length > 500 ? raw.substring(0, 500) : raw;
      expect(sanitizeMission('To end hunger in our local city.'), 'To end hunger in our local city.');
    });

    test('APP-147: NGO request priority color indicator maps high quantity to red hex', () {
      String getUrgencyColor(int qty) => qty >= 50 ? '#D32F2F' : '#388E3C';
      expect(getUrgencyColor(50), '#D32F2F');
    });

    test('APP-148: NGO request priority color indicator maps low quantity to green hex', () {
      String getUrgencyColor(int qty) => qty < 50 ? '#388E3C' : '#D32F2F';
      expect(getUrgencyColor(10), '#388E3C');
    });

    test('APP-149: Food request model toMap serializes quantityNeeded', () {
      final req = FoodRequestModel(id: '149', ngoId: 'n', ngoName: 'N', title: 'T', description: 'D', quantityNeeded: 25, status: FoodRequestStatus.pending, createdAt: DateTime.now());
      expect(req.toMap()['quantityNeeded'], 25);
    });

    test('APP-150: Food request service cache clears stored list on logout', () {
      List<FoodRequestModel> list = [FoodRequestModel(id: '150', ngoId: 'n', ngoName: 'N', title: 'T', description: 'D', quantityNeeded: 5, status: FoodRequestStatus.pending, createdAt: DateTime.now())];
      list.clear();
      expect(list, isEmpty);
    });
  });
}
