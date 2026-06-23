// ============================================================
//  NAVIGATION TEST (chạy trên thiết bị) — navigation_test_on_device.dart
//
//  Giống Navigation Test gốc nhưng chạy trên thiết bị thật
//  bằng cách dùng IntegrationTestWidgetsFlutterBinding
//  → Có thể nhìn thấy test chạy trên màn hình app
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_flutter_test/screens/home_screen.dart';
import 'package:demo_flutter_test/screens/detail_screen.dart';

void main() {
  // Bắt buộc: Khởi tạo binding để chạy kiểm thử giao diện trực tiếp trên màn hình thiết bị
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Tests - On Device', () {
    // Hàm phụ trợ tạo MaterialApp với HomeScreen là trang đầu tiên để kiểm thử điều hướng độc lập
    Widget buildApp() {
      return const MaterialApp(
        home: HomeScreen(),
      );
    }

    // ── TEST CASE 1: Điều hướng từ màn hình chính sang màn hình chi tiết ──
    // Mô tả: Kiểm tra hành động nhấn nút "Xem chi tiết" trên HomeScreen
    // có mở đúng màn hình DetailScreen và hiển thị đúng thông tin hay không.
    testWidgets('nhấn "Xem chi tiết" → mở DetailScreen',
        (WidgetTester tester) async {
      // 1. Render app
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Xác nhận ban đầu: Đang ở HomeScreen và chưa có DetailScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(DetailScreen), findsNothing);

      // 2. Hành động: Nhấn nút di chuyển màn hình theo Key
      await tester.tap(find.byKey(const Key('navigate_button')));
      // Chờ hoàn tất hoạt họa chuyển trang (page transition animation)
      await tester.pumpAndSettle();

      // 3. Xác thực: Đang hiển thị DetailScreen với tiêu đề mong muốn
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.byKey(const Key('detail_title')), findsOneWidget);
      expect(find.text('Màn hình Chi tiết'), findsOneWidget);
    });

    // ── TEST CASE 2: Quay lại màn hình chính bằng nút Quay lại tự chế ──
    // Mô tả: Di chuyển đến DetailScreen, sau đó nhấn nút "Quay lại" (back button)
    // được thiết kế trên giao diện của DetailScreen để quay về HomeScreen.
    testWidgets('nhấn "Quay lại" → về HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Di chuyển sang DetailScreen
      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // Xác nhận đang ở DetailScreen
      expect(find.byType(DetailScreen), findsOneWidget);

      // 2. Hành động: Nhấn nút quay lại tự chế có Key là 'back_button'
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // 3. Xác thực: Đã trở về HomeScreen thành công và DetailScreen biến mất
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(DetailScreen), findsNothing);
    });

    // ── TEST CASE 3: Quay lại bằng nút Back mặc định của AppBar ──
    // Mô tả: Di chuyển đến DetailScreen, sau đó tìm nút Back mặc định
    // ở góc trái của AppBar (BackButton widget) và nhấn để quay về HomeScreen.
    testWidgets('nhấn AppBar back button → về HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Di chuyển sang DetailScreen
      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // 2. Hành động: Tìm nút back của AppBar (kiểu BackButton) và nhấn
      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // 3. Xác thực: Đã quay về HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    // ── TEST CASE 4: Xác thực hiển thị giao diện của DetailScreen ──
    // Mô tả: Di chuyển đến DetailScreen và kiểm tra các thành phần giao diện
    // xem có hiển thị đúng icon, tiêu đề appBar và đoạn văn bản chào mừng hay không.
    testWidgets('DetailScreen hiển thị đúng nội dung sau navigate',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Di chuyển sang DetailScreen
      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // 3. Xác thực: Các element hiển thị chính xác
      expect(find.text('Chi tiết'), findsOneWidget); // Tiêu đề AppBar
      expect(find.text('Bạn đã navigate thành công!'), findsOneWidget); // Mô tả
      expect(find.byIcon(Icons.info_outline), findsOneWidget); // Icon thông tin màu xanh lá
    });
  });
}
