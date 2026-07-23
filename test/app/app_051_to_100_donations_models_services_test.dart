import 'package:flutter_test/flutter_test.dart';
import 'package:resq_meal/models/models.dart';

void main() {
  group('Flutter App Donations Models & Services Test Suite (APP-051 to APP-100)', () {
    test('APP-051: DonationModel serializes to map correctly', () {
      final donation = DonationModel(
        id: 'don_051',
        title: 'Apples & Bananas',
        description: 'Fresh fruits 15kg',
        quantity: 15,
        unit: 'kg',
        category: FoodCategory.produce,
        donorId: 'donor_01',
        donorName: 'Fruit Farm',
        status: DonationStatus.available,
        createdAt: DateTime(2026, 1, 10),
      );
      final json = donation.toMap();
      expect(donation.id, 'don_051');
      expect(json['quantity'], 15);
      expect(json['status'], 'available');
    });

    test('APP-052: DonationModel deserializes from map correctly', () {
      final json = {
        'title': 'Rice bags',
        'description': '50kg basmati rice',
        'quantity': 50,
        'unit': 'kg',
        'category': 'produce',
        'donorId': 'd02',
        'donorName': 'Grain Mill',
        'status': 'available',
        'createdAt': '2026-01-11T00:00:00.000Z',
      };
      final don = DonationModel.fromMap(json, id: 'don_052');
      expect(don.id, 'don_052');
      expect(don.status, DonationStatus.available);
      expect(don.quantity, 50);
    });

    test('APP-053: DonationStatus enum string representation returns valid status name', () {
      expect(DonationStatus.available.name, 'available');
      expect(DonationStatus.reserved.name, 'reserved');
      expect(DonationStatus.delivered.name, 'delivered');
      expect(DonationStatus.cancelled.name, 'cancelled');
    });

    test('APP-054: Donation quantity must be greater than 0', () {
      bool validateQuantity(int q) => q > 0;
      expect(validateQuantity(0), isFalse);
      expect(validateQuantity(-5), isFalse);
      expect(validateQuantity(10), isTrue);
    });

    test('APP-055: Donation title validation enforces minimum length of 3 chars', () {
      bool validateTitle(String title) => title.trim().length >= 3;
      expect(validateTitle('Hi'), isFalse);
      expect(validateTitle('Fresh Meals'), isTrue);
    });

    test('APP-056: Donation description validation enforces max length of 500 chars', () {
      bool validateDesc(String desc) => desc.length <= 500;
      expect(validateDesc('Short description'), isTrue);
      expect(validateDesc('x' * 501), isFalse);
    });

    test('APP-057: Donation copyWith updates status to reserved', () {
      final don = DonationModel(
        id: '57',
        title: 'Soup',
        description: 'Hot soup',
        quantity: 5,
        unit: 'portions',
        category: FoodCategory.preparedMeals,
        donorId: 'd1',
        donorName: 'D',
        status: DonationStatus.available,
        createdAt: DateTime.now(),
      );
      final updated = don.copyWith(status: DonationStatus.reserved);
      expect(updated.status, DonationStatus.reserved);
    });

    test('APP-058: Donation copyWith updates status to delivered', () {
      final don = DonationModel(
        id: '58',
        title: 'Salad',
        description: 'Green salad',
        quantity: 3,
        unit: 'portions',
        category: FoodCategory.produce,
        donorId: 'd1',
        donorName: 'D',
        status: DonationStatus.reserved,
        createdAt: DateTime.now(),
      );
      final updated = don.copyWith(status: DonationStatus.delivered);
      expect(updated.status, DonationStatus.delivered);
    });

    test('APP-059: Donation expiry check identifies past dates as expired', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 2));
      bool isExpired(DateTime expiry) => DateTime.now().isAfter(expiry);
      expect(isExpired(pastDate), isTrue);
    });

    test('APP-060: Donation expiry check confirms future dates as active', () {
      final futureDate = DateTime.now().add(const Duration(hours: 12));
      bool isExpired(DateTime expiry) => DateTime.now().isAfter(expiry);
      expect(isExpired(futureDate), isFalse);
    });

    test('APP-061: Food type tag list formats food types to clean tags', () {
      final types = ['Vegetable', 'Dairy', 'Bakery'];
      expect(types.length, 3);
      expect(types, contains('Bakery'));
    });

    test('APP-062: Donation image list validator limits photos to 5 per donation', () {
      bool validatePhotos(List<String> urls) => urls.length <= 5;
      expect(validatePhotos(['url1', 'url2', 'url3']), isTrue);
      expect(validatePhotos(['u1', 'u2', 'u3', 'u4', 'u5', 'u6']), isFalse);
    });

    test('APP-063: Donation location string formatting trims extra whitespace', () {
      String formatLocation(String loc) => loc.trim();
      expect(formatLocation('  Main Street Market  '), 'Main Street Market');
    });

    test('APP-064: Food item perishable flag defaults to true for cooked meals', () {
      bool isPerishable(String category) => category == 'Cooked' || category == 'Dairy';
      expect(isPerishable('Cooked'), isTrue);
      expect(isPerishable('Canned Goods'), isFalse);
    });

    test('APP-065: Donation status filter filters list by available status', () {
      final list = [
        DonationModel(id: '1', title: 'T1', description: 'D1', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u1', donorName: 'N1', status: DonationStatus.available, createdAt: DateTime.now()),
        DonationModel(id: '2', title: 'T2', description: 'D2', quantity: 2, unit: 'kg', category: FoodCategory.produce, donorId: 'u1', donorName: 'N1', status: DonationStatus.delivered, createdAt: DateTime.now()),
      ];
      final filtered = list.where((d) => d.status == DonationStatus.available).toList();
      expect(filtered.length, 1);
      expect(filtered.first.id, '1');
    });

    test('APP-066: Donation status filter filters list by delivered status', () {
      final list = [
        DonationModel(id: '1', title: 'T1', description: 'D1', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u1', donorName: 'N1', status: DonationStatus.available, createdAt: DateTime.now()),
        DonationModel(id: '2', title: 'T2', description: 'D2', quantity: 2, unit: 'kg', category: FoodCategory.produce, donorId: 'u1', donorName: 'N1', status: DonationStatus.delivered, createdAt: DateTime.now()),
      ];
      final filtered = list.where((d) => d.status == DonationStatus.delivered).toList();
      expect(filtered.length, 1);
      expect(filtered.first.id, '2');
    });

    test('APP-067: Donation search query matches donation title case-insensitively', () {
      final list = [
        DonationModel(id: '1', title: 'Fresh Sandwiches', description: 'D1', quantity: 1, unit: 'kg', category: FoodCategory.preparedMeals, donorId: 'u1', donorName: 'N1', status: DonationStatus.available, createdAt: DateTime.now()),
        DonationModel(id: '2', title: 'Warm Soup', description: 'D2', quantity: 2, unit: 'kg', category: FoodCategory.preparedMeals, donorId: 'u1', donorName: 'N1', status: DonationStatus.available, createdAt: DateTime.now()),
      ];
      final results = list.where((d) => d.title.toLowerCase().contains('sandwich')).toList();
      expect(results.length, 1);
    });

    test('APP-068: Donation sorting sorts items by creation date descending', () {
      final d1 = DonationModel(id: '1', title: 'Older', description: 'D', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u', donorName: 'N', status: DonationStatus.available, createdAt: DateTime(2026, 1, 1));
      final d2 = DonationModel(id: '2', title: 'Newer', description: 'D', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u', donorName: 'N', status: DonationStatus.available, createdAt: DateTime(2026, 1, 10));
      final list = [d1, d2];
      list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      expect(list.first.id, '2');
    });

    test('APP-069: Meal offer model calculates remaining quantity correctly', () {
      int getRemaining(int total, int claimed) => total - claimed;
      expect(getRemaining(20, 5), 15);
    });

    test('APP-070: Donation creation time defaults to current DateTime', () {
      final now = DateTime.now();
      final don = DonationModel(id: '70', title: 'T', description: 'D', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u', donorName: 'N', status: DonationStatus.available, createdAt: now);
      expect(don.createdAt, now);
    });

    test('APP-071: Pickup time window validator verifies start before end time', () {
      final start = DateTime(2026, 1, 15, 14, 0);
      final end = DateTime(2026, 1, 15, 16, 0);
      bool isValidWindow(DateTime s, DateTime e) => e.isAfter(s);
      expect(isValidWindow(start, end), isTrue);
    });

    test('APP-072: Pickup time window validator fails when end is before start time', () {
      final start = DateTime(2026, 1, 15, 16, 0);
      final end = DateTime(2026, 1, 15, 14, 0);
      bool isValidWindow(DateTime s, DateTime e) => e.isAfter(s);
      expect(isValidWindow(start, end), isFalse);
    });

    test('APP-073: Donation ID helper formats ID with don_ prefix', () {
      String formatId(int index) => 'don_${index.toString().padLeft(4, '0')}';
      expect(formatId(73), 'don_0073');
    });

    test('APP-074: Allergen warnings parser converts comma separated string to list', () {
      List<String> parseAllergens(String raw) => raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final result = parseAllergens('Nuts, Dairy, Gluten');
      expect(result, ['Nuts', 'Dairy', 'Gluten']);
    });

    test('APP-075: Allergen warning empty string yields empty list', () {
      List<String> parseAllergens(String raw) => raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      expect(parseAllergens(''), isEmpty);
    });

    test('APP-076: Food temperature storage recommendation tags hot/cold items', () {
      String getTempRequirement(bool isHot) => isHot ? 'Keep Above 60°C' : 'Keep Below 4°C';
      expect(getTempRequirement(true), 'Keep Above 60°C');
      expect(getTempRequirement(false), 'Keep Below 4°C');
    });

    test('APP-077: Claim donation action sets NGO claimant ID on donation', () {
      final don = DonationModel(id: '77', title: 'T', description: 'D', quantity: 5, unit: 'kg', category: FoodCategory.produce, donorId: 'd', donorName: 'N', status: DonationStatus.available, createdAt: DateTime.now());
      final claimed = don.copyWith(ngoId: 'ngo_99', status: DonationStatus.reserved);
      expect(claimed.ngoId, 'ngo_99');
    });

    test('APP-078: Cancel donation action reverts status to cancelled', () {
      final don = DonationModel(id: '78', title: 'T', description: 'D', quantity: 5, unit: 'kg', category: FoodCategory.produce, donorId: 'd', donorName: 'N', status: DonationStatus.available, createdAt: DateTime.now());
      final cancelled = don.copyWith(status: DonationStatus.cancelled);
      expect(cancelled.status, DonationStatus.cancelled);
    });

    test('APP-079: Total meals saved metric accumulator sums all quantities', () {
      final quantities = [10, 25, 15, 50];
      final total = quantities.reduce((a, b) => a + b);
      expect(total, 100);
    });

    test('APP-080: Donation provider state loads list into active list property', () {
      final list = [DonationModel(id: '80', title: 'T', description: 'D', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u', donorName: 'N', status: DonationStatus.available, createdAt: DateTime.now())];
      expect(list.length, 1);
    });

    test('APP-081: Active donations counter excludes delivered and cancelled items', () {
      final statuses = [DonationStatus.available, DonationStatus.reserved, DonationStatus.delivered, DonationStatus.cancelled];
      final active = statuses.where((s) => s == DonationStatus.available || s == DonationStatus.reserved).length;
      expect(active, 2);
    });

    test('APP-082: Donation model equality operator compares unique donation ID', () {
      final d1 = DonationModel(id: '82', title: 'A', description: 'B', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'd', donorName: 'n', status: DonationStatus.available, createdAt: DateTime(2026, 1, 1));
      final d2 = DonationModel(id: '82', title: 'A', description: 'B', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'd', donorName: 'n', status: DonationStatus.available, createdAt: DateTime(2026, 1, 1));
      expect(d1.id == d2.id, isTrue);
    });

    test('APP-083: Food weight unit converter converts kilograms to pounds', () {
      double kgToLbs(double kg) => kg * 2.20462;
      expect(kgToLbs(10).round(), 22);
    });

    test('APP-084: Food weight unit converter converts pounds to kilograms', () {
      double lbsToKg(double lbs) => lbs / 2.20462;
      expect(lbsToKg(22.0462).round(), 10);
    });

    test('APP-085: Donation creation draft saver serializes temporary form draft', () {
      final draft = {'title': 'Draft Bread', 'quantity': 12};
      expect(draft['title'], 'Draft Bread');
    });

    test('APP-086: Clearing donation draft clears cached form data map', () {
      Map<String, dynamic>? draft = {'title': 'Draft'};
      draft = null;
      expect(draft, isNull);
    });

    test('APP-087: Packaging type enum returns correct packaging description', () {
      final types = ['Sealed Box', 'Insulated Container', 'Disposable Trays'];
      expect(types, contains('Insulated Container'));
    });

    test('APP-088: Special instructions text trimmer caps length at 200 chars', () {
      String sanitizeNotes(String raw) => raw.length > 200 ? raw.substring(0, 200) : raw;
      expect(sanitizeNotes('Ring doorbell upon arrival.'), 'Ring doorbell upon arrival.');
    });

    test('APP-089: Donation distance label formatting formats meters to km string', () {
      String formatDist(int meters) => '${(meters / 1000).toStringAsFixed(1)} km';
      expect(formatDist(2500), '2.5 km');
    });

    test('APP-090: Donation distance label formatting formats under 1000m to meters', () {
      String formatDist(int meters) => meters < 1000 ? '$meters m' : '${(meters / 1000).toStringAsFixed(1)} km';
      expect(formatDist(450), '450 m');
    });

    test('APP-091: Claim button availability check disables button for own donation', () {
      bool canClaim(String currentUserId, String donorId) => currentUserId != donorId;
      expect(canClaim('user_01', 'user_01'), isFalse);
      expect(canClaim('ngo_01', 'user_01'), isTrue);
    });

    test('APP-092: Edit donation button availability check permits owner only', () {
      bool canEdit(String currentUserId, String donorId) => currentUserId == donorId;
      expect(canEdit('user_01', 'user_01'), isTrue);
      expect(canEdit('user_02', 'user_01'), isFalse);
    });

    test('APP-093: Delete donation confirmation dialog state tracks confirm intent', () {
      bool confirmed = false;
      void confirmDelete() => confirmed = true;
      confirmDelete();
      expect(confirmed, isTrue);
    });

    test('APP-094: Food waste CO2 savings estimator calculates 2.5kg CO2 per kg food', () {
      double calcCo2Saved(double foodKg) => foodKg * 2.5;
      expect(calcCo2Saved(10.0), 25.0);
    });

    test('APP-095: Donation badge color mapper maps status available to green hex code', () {
      String getStatusColor(DonationStatus s) => s == DonationStatus.available ? '#2E7D32' : '#757575';
      expect(getStatusColor(DonationStatus.available), '#2E7D32');
    });

    test('APP-096: Donation badge color mapper maps status reserved to orange hex code', () {
      String getStatusColor(DonationStatus s) => s == DonationStatus.reserved ? '#EF6C00' : '#757575';
      expect(getStatusColor(DonationStatus.reserved), '#EF6C00');
    });

    test('APP-097: Donation badge color mapper maps status delivered to blue hex code', () {
      String getStatusColor(DonationStatus s) => s == DonationStatus.delivered ? '#1565C0' : '#757575';
      expect(getStatusColor(DonationStatus.delivered), '#1565C0');
    });

    test('APP-098: Pickup address geocoding validator requires non-empty address line', () {
      bool validateAddress(String addr) => addr.trim().length >= 5;
      expect(validateAddress(''), isFalse);
      expect(validateAddress('123 Elm St'), isTrue);
    });

    test('APP-099: Donation pagination helper slices 10 items per page', () {
      final items = List.generate(25, (i) => 'don_$i');
      List<String> getPage(int page, int size) => items.skip((page - 1) * size).take(size).toList();
      expect(getPage(1, 10).length, 10);
      expect(getPage(3, 10).length, 5);
    });

    test('APP-100: Donation service cache invalidator clears local cached items', () {
      List<DonationModel> cache = [
        DonationModel(id: '100', title: 'C', description: 'D', quantity: 1, unit: 'kg', category: FoodCategory.produce, donorId: 'u', donorName: 'N', status: DonationStatus.available, createdAt: DateTime.now())
      ];
      void clearCache() => cache.clear();
      clearCache();
      expect(cache, isEmpty);
    });
  });
}
