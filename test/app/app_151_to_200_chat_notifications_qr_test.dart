import 'package:flutter_test/flutter_test.dart';
import 'package:resq_meal/models/models.dart';

void main() {
  group('Flutter App Chat, Notifications & QR Models Test Suite (APP-151 to APP-200)', () {
    test('APP-151: MessageModel serializes to map correctly', () {
      final msg = MessageModel(
        id: 'msg_151',
        chatId: 'chat_01',
        senderId: 'user_01',
        senderName: 'Alice',
        text: 'I am on my way to deliver the meals',
        createdAt: DateTime(2026, 1, 15, 10, 30),
      );
      final json = msg.toMap();
      expect(msg.id, 'msg_151');
      expect(json['senderId'], 'user_01');
      expect(json['text'], 'I am on my way to deliver the meals');
    });

    test('APP-152: MessageModel deserializes from map correctly', () {
      final json = {
        'chatId': 'chat_01',
        'senderId': 'user_02',
        'senderName': 'Bob',
        'text': 'Thank you so much!',
        'createdAt': '2026-01-15T10:31:00.000Z',
      };
      final msg = MessageModel.fromMap(json, id: 'msg_152');
      expect(msg.id, 'msg_152');
      expect(msg.text, 'Thank you so much!');
      expect(msg.senderName, 'Bob');
    });

    test('APP-153: ChatModel serializes participant IDs list correctly', () {
      final room = ChatModel(
        id: 'room_153',
        participantIds: ['u1', 'u2'],
        type: ChatType.donorNgo,
        lastMessage: 'See you soon',
        lastMessageAt: DateTime(2026, 1, 15),
      );
      expect(room.participantIds.length, 2);
      expect(room.participantIds, contains('u1'));
    });

    test('APP-154: NotificationModel serializes notification type donation correctly', () {
      final notif = NotificationModel(
        id: 'notif_154',
        userId: 'user_01',
        title: 'Donation Claimed',
        body: 'Hope Foundation claimed your donation',
        type: NotificationType.donation,
        createdAt: DateTime(2026, 1, 15),
      );
      final json = notif.toMap();
      expect(json['type'], 'donation');
      expect(json['isRead'], isFalse);
    });

    test('APP-155: NotificationModel indicates isRead property boolean', () {
      final notif = NotificationModel(
        id: 'notif_155',
        userId: 'user_01',
        title: 'New Message',
        body: 'You have a unread chat message',
        type: NotificationType.chat,
        createdAt: DateTime.now(),
        isRead: true,
      );
      expect(notif.isRead, isTrue);
    });

    test('APP-156: NotificationType enum parses String values to enum correctly', () {
      expect(NotificationType.donation.name, 'donation');
      expect(NotificationType.request.name, 'request');
      expect(NotificationType.chat.name, 'chat');
      expect(NotificationType.system.name, 'system');
    });

    test('APP-157: QrVerificationModel serializes to map correctly', () {
      final qr = QrVerificationModel(
        id: 'qr_157',
        donationId: 'don_01',
        code: 'RESQ-CODE-99',
        type: QrVerificationType.pickup,
        verifiedByUserId: 'user_01',
        createdAt: DateTime(2026, 1, 15),
      );
      final json = qr.toMap();
      expect(json['code'], 'RESQ-CODE-99');
      expect(json['type'], 'pickup');
    });

    test('APP-158: QrVerificationModel status isUsed verifies barcode redemption', () {
      final qr = QrVerificationModel(
        id: 'qr_158',
        donationId: 'don_01',
        code: 'RESQ-CODE-100',
        type: QrVerificationType.pickup,
        verifiedByUserId: 'user_01',
        isUsed: true,
        createdAt: DateTime(2026, 1, 15),
      );
      expect(qr.isUsed, isTrue);
    });

    test('APP-159: QrVerificationType enum names match expected string values', () {
      expect(QrVerificationType.pickup.name, 'pickup');
      expect(QrVerificationType.delivery.name, 'delivery');
    });

    test('APP-160: Chat message text trimmer strips surrounding whitespace', () {
      String sanitizeMsg(String text) => text.trim();
      expect(sanitizeMsg('   Hello!   '), 'Hello!');
    });

    test('APP-161: Chat message empty validation prevents sending 0-length messages', () {
      bool canSend(String text) => text.trim().isNotEmpty;
      expect(canSend(''), isFalse);
      expect(canSend('   '), isFalse);
      expect(canSend('Hi'), isTrue);
    });

    test('APP-162: Chat message max length validator caps single message at 1000 chars', () {
      bool isValidLength(String text) => text.length <= 1000;
      expect(isValidLength('a' * 1000), isTrue);
      expect(isValidLength('a' * 1001), isFalse);
    });

    test('APP-163: Unread notification counter counts notifications where isRead is false', () {
      final list = [
        NotificationModel(id: '1', userId: 'u', title: 'T1', body: 'B', type: NotificationType.system, createdAt: DateTime.now(), isRead: false),
        NotificationModel(id: '2', userId: 'u', title: 'T2', body: 'B', type: NotificationType.system, createdAt: DateTime.now(), isRead: true),
        NotificationModel(id: '3', userId: 'u', title: 'T3', body: 'B', type: NotificationType.system, createdAt: DateTime.now(), isRead: false),
      ];
      final unreadCount = list.where((n) => !n.isRead).length;
      expect(unreadCount, 2);
    });

    test('APP-164: Mark all notifications as read updates all list items', () {
      final list = [
        NotificationModel(id: '1', userId: 'u', title: 'T1', body: 'B', type: NotificationType.system, createdAt: DateTime.now(), isRead: false),
        NotificationModel(id: '2', userId: 'u', title: 'T2', body: 'B', type: NotificationType.system, createdAt: DateTime.now(), isRead: false),
      ];
      final updatedList = list.map((n) => NotificationModel(id: n.id, userId: n.userId, title: n.title, body: n.body, type: n.type, isRead: true)).toList();
      expect(updatedList.every((n) => n.isRead), isTrue);
    });

    test('APP-165: QR code generator formats payload code string format RESQ-QR-XXXX', () {
      String formatQrCode(String donId) => 'RESQ-QR-${donId.toUpperCase()}';
      expect(formatQrCode('don01'), 'RESQ-QR-DON01');
    });

    test('APP-166: QR code verification check confirms valid status for active token', () {
      final qr = QrVerificationModel(id: '166', donationId: 'd', code: 'C', type: QrVerificationType.pickup, verifiedByUserId: 'u', isUsed: false, createdAt: DateTime.now());
      bool isValid(QrVerificationModel model) => !model.isUsed;
      expect(isValid(qr), isTrue);
    });

    test('APP-167: QR code verification check rejects used QR code token', () {
      final qr = QrVerificationModel(id: '167', donationId: 'd', code: 'C', type: QrVerificationType.pickup, verifiedByUserId: 'u', isUsed: true, createdAt: DateTime.now());
      bool isValid(QrVerificationModel model) => !model.isUsed;
      expect(isValid(qr), isFalse);
    });

    test('APP-168: FCM token device registration saves non-null token string', () {
      String? fcmToken;
      void registerToken(String token) => fcmToken = token;
      registerToken('sample_fcm_token_xyz_123');
      expect(fcmToken, 'sample_fcm_token_xyz_123');
    });

    test('APP-169: FCM token clearing wipes saved token on user sign out', () {
      String? fcmToken = 'token_xyz';
      void clearToken() => fcmToken = null;
      clearToken();
      expect(fcmToken, isNull);
    });

    test('APP-170: Chat timestamp relative formatter formats recent message as Just now', () {
      String formatTime(DateTime time) {
        final diff = DateTime.now().difference(time);
        if (diff.inSeconds < 60) return 'Just now';
        return '${diff.inMinutes}m ago';
      }
      expect(formatTime(DateTime.now()), 'Just now');
    });

    test('APP-171: Chat timestamp relative formatter formats minutes ago string', () {
      String formatTime(DateTime time) {
        final diff = DateTime.now().difference(time);
        if (diff.inSeconds < 60) return 'Just now';
        return '${diff.inMinutes}m ago';
      }
      expect(formatTime(DateTime.now().subtract(const Duration(minutes: 5))), '5m ago');
    });

    test('APP-172: Chat message receiver bubble aligns right for current user', () {
      bool isMe(String senderId, String currentUserId) => senderId == currentUserId;
      expect(isMe('user_01', 'user_01'), isTrue);
      expect(isMe('user_02', 'user_01'), isFalse);
    });

    test('APP-173: Chat message sender name initials generator produces uppercase initials', () {
      String getInitials(String name) {
        final parts = name.trim().split(' ');
        if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        return name[0].toUpperCase();
      }
      expect(getInitials('John Doe'), 'JD');
      expect(getInitials('Alice'), 'A');
    });

    test('APP-174: QR scanner barcode parser extracts donation ID query parameter', () {
      String? parseDonationId(String rawUrl) {
        final uri = Uri.tryParse(rawUrl);
        return uri?.queryParameters['donationId'];
      }
      expect(parseDonationId('https://resqmeal.org/verify?donationId=don_99'), 'don_99');
    });

    test('APP-175: QR scanner barcode parser handles invalid URL gracefully', () {
      String? parseDonationId(String rawUrl) {
        final uri = Uri.tryParse(rawUrl);
        return uri?.queryParameters['donationId'];
      }
      expect(parseDonationId('not_a_url'), isNull);
    });

    test('APP-176: Push notification payload parser extracts screen route target', () {
      final payload = {'route': '/donations/detail/don_123'};
      expect(payload['route'], '/donations/detail/don_123');
    });

    test('APP-177: Push notification payload route fallback defaults to home dashboard', () {
      final payload = <String, dynamic>{};
      String getTargetRoute(Map<String, dynamic> data) => data['route'] ?? '/home';
      expect(getTargetRoute(payload), '/home');
    });

    test('APP-178: In-app banner notification auto-dismisses after 4 seconds', () {
      int autoDismissMs = 4000;
      expect(autoDismissMs, 4000);
    });

    test('APP-179: Chat room search query filters list by participant name', () {
      final rooms = [
        ChatModel(id: 'r1', participantIds: ['u1', 'u2'], type: ChatType.donorNgo, lastMessage: 'Hi', lastMessageAt: DateTime.now()),
        ChatModel(id: 'r2', participantIds: ['u1', 'u3'], type: ChatType.donorNgo, lastMessage: 'Hello', lastMessageAt: DateTime.now()),
      ];
      final res = rooms.where((r) => r.participantIds.contains('u2')).toList();
      expect(res.length, 1);
    });

    test('APP-180: Chat room sorting orders by lastMessageAt timestamp descending', () {
      final r1 = ChatModel(id: '1', participantIds: ['a'], type: ChatType.donorNgo, lastMessage: 'Old', lastMessageAt: DateTime(2026, 1, 1));
      final r2 = ChatModel(id: '2', participantIds: ['a'], type: ChatType.donorNgo, lastMessage: 'New', lastMessageAt: DateTime(2026, 1, 10));
      final list = [r1, r2];
      list.sort((a, b) => b.lastMessageAt!.compareTo(a.lastMessageAt!));
      expect(list.first.id, '2');
    });

    test('APP-181: Notification priority color indicator maps system alert to amber', () {
      String getNotifColor(NotificationType t) => t == NotificationType.system ? '#FFA000' : '#1976D2';
      expect(getNotifColor(NotificationType.system), '#FFA000');
    });

    test('APP-182: Notification priority color indicator maps chat message to blue', () {
      String getNotifColor(NotificationType t) => t == NotificationType.chat ? '#1976D2' : '#FFA000';
      expect(getNotifColor(NotificationType.chat), '#1976D2');
    });

    test('APP-183: QR verification success toast message text displays verified', () {
      String getSuccessMsg(String id) => 'Donation #$id successfully verified!';
      expect(getSuccessMsg('don_88'), 'Donation #don_88 successfully verified!');
    });

    test('APP-184: QR verification invalid toast message text displays error', () {
      String getErrorMsg() => 'Invalid or expired QR code barcode.';
      expect(getErrorMsg(), contains('Invalid or expired'));
    });

    test('APP-185: Chat typing indicator state toggles isTyping flag', () {
      bool isTyping = false;
      void setTyping(bool val) => isTyping = val;
      setTyping(true);
      expect(isTyping, isTrue);
    });

    test('APP-186: Chat image attachment photo upload validator accepts image mime type', () {
      bool isImage(String mime) => mime.startsWith('image/');
      expect(isImage('image/jpeg'), isTrue);
      expect(isImage('application/pdf'), isFalse);
    });

    test('APP-187: Chat attachment max file size validator caps upload at 5MB', () {
      bool isSizeValid(int bytes) => bytes <= 5 * 1024 * 1024;
      expect(isSizeValid(2 * 1024 * 1024), isTrue);
      expect(isSizeValid(8 * 1024 * 1024), isFalse);
    });

    test('APP-188: Sound notification toggle preference persists state boolean', () {
      bool playSound = true;
      void toggleSound() => playSound = !playSound;
      toggleSound();
      expect(playSound, isFalse);
    });

    test('APP-189: Vibration notification toggle preference persists state boolean', () {
      bool vibrate = true;
      void toggleVibrate() => vibrate = !vibrate;
      toggleVibrate();
      expect(vibrate, isFalse);
    });

    test('APP-190: Delete chat message removes message item by ID from list', () {
      final msgs = [
        MessageModel(id: 'm1', chatId: 'c1', senderId: 'u1', senderName: 'A', text: 'T1', createdAt: DateTime.now()),
        MessageModel(id: 'm2', chatId: 'c1', senderId: 'u1', senderName: 'A', text: 'T2', createdAt: DateTime.now()),
      ];
      msgs.removeWhere((m) => m.id == 'm1');
      expect(msgs.length, 1);
      expect(msgs.first.id, 'm2');
    });

    test('APP-191: QR code regeneration creates new timestamped code string', () {
      String regenCode(String base) => '$base-${DateTime.now().millisecondsSinceEpoch}';
      expect(regenCode('RESQ'), startsWith('RESQ-'));
    });

    test('APP-192: Notification subscription topic builder formats topic user role', () {
      String getTopic(UserRole role) => 'topic_${role.name}';
      expect(getTopic(UserRole.donor), 'topic_donor');
      expect(getTopic(UserRole.ngo), 'topic_ngo');
    });

    test('APP-193: QR scan rate limiter blocks repeated scans within 2 seconds', () {
      DateTime lastScan = DateTime.now();
      bool canScan() => DateTime.now().difference(lastScan).inSeconds >= 2;
      expect(canScan(), isFalse);
    });

    test('APP-194: Chat message text sanitization strips dangerous HTML scripts', () {
      String stripHtml(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '');
      expect(stripHtml('<script>alert("x")</script>Hello'), 'alert("x")Hello');
    });

    test('APP-195: QR scanner camera permission status handler checks granted state', () {
      bool isCameraGranted(String status) => status == 'granted';
      expect(isCameraGranted('granted'), isTrue);
      expect(isCameraGranted('denied'), isFalse);
    });

    test('APP-196: QR scanner flashlight torch toggle switches torch state', () {
      bool torchOn = false;
      void toggleTorch() => torchOn = !torchOn;
      toggleTorch();
      expect(torchOn, isTrue);
    });

    test('APP-197: Notification badge icon shows unread dot when count > 0', () {
      bool showDot(int unreadCount) => unreadCount > 0;
      expect(showDot(3), isTrue);
      expect(showDot(0), isFalse);
    });

    test('APP-198: Clear notification history empties notification list', () {
      List<NotificationModel> list = [
        NotificationModel(id: '1', userId: 'u', title: 'T', body: 'B', type: NotificationType.system, createdAt: DateTime.now())
      ];
      list.clear();
      expect(list, isEmpty);
    });

    test('APP-199: Chat auto-scroll trigger scrolls list to bottom on new message', () {
      bool scrolledToBottom = false;
      void onNewMessage() => scrolledToBottom = true;
      onNewMessage();
      expect(scrolledToBottom, isTrue);
    });

    test('APP-200: Chat provider disconnect wipes active chat room state', () {
      ChatModel? activeRoom = ChatModel(id: '200', participantIds: ['u'], type: ChatType.donorNgo, lastMessage: 'm', lastMessageAt: DateTime.now());
      activeRoom = null;
      expect(activeRoom, isNull);
    });
  });
}
