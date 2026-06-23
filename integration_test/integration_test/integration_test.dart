// ============================================================
//  INTEGRATION TEST — integration_test.dart
//
//  Khác biệt so với Widget Test:
//  ┌─ Chạy trên thiết bị/emulator thật (không phải virtual)
//  ├─ IntegrationTestWidgetsFlutterBinding.ensureInitialized()
//  │   → Khởi tạo binding cho integration test
//  ├─ Test toàn bộ app thật (MyApp), không chỉ 1 widget
//  └─ Kiểm tra luồng người dùng end-to-end
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_flutter_test/main.dart';
import 'package:demo_flutter_test/screens/home_screen.dart';
import 'package:demo_flutter_test/screens/detail_screen.dart';

void main() {
  // Bắt buộc: Thiết lập binding liên kết với thiết bị thật để chạy test có giao diện trực quan
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    
    // ── TEST CASE 1: Khởi động ứng dụng và hiển thị màn hình chính HomeScreen ──
    // Mô tả: Kiểm thử đầu cuối (End-to-End) xem ứng dụng thật chạy lên có đúng màn hình
    // HomeScreen với đầy đủ tiêu đề "Trang chủ", bộ đếm 0, nút điều hướng hay không.
    testWidgets('App khởi động và hiển thị HomeScreen đúng',
        (WidgetTester tester) async {
      // 1. Chạy ứng dụng thật (MyApp)
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 2. Xác thực cấu trúc giao diện
      expect(find.byType(HomeScreen), findsOneWidget); // Phải mở HomeScreen đầu tiên
      expect(find.text('Trang chủ'), findsOneWidget); // Tiêu đề trang chủ đúng màu xanh dương
      expect(find.text('Số đếm hiện tại:'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Số đếm ban đầu phải bằng 0
      expect(find.text('Xem chi tiết'), findsOneWidget); // Nút điều hướng hiển thị đúng nhãn
    });

    // ── TEST CASE 2: Luồng tương tác tăng giảm bộ đếm tích hợp trên ứng dụng thật ──
    // Mô tả: Kiểm thử xem hành vi nhấn nút + và nút - có cập nhật bộ đếm đúng
    // và hiển thị trực quan lên màn hình thiết bị hay không.
    testWidgets('Tăng và giảm counter hoạt động đúng trên app thật',
        (WidgetTester tester) async {
      // 1. Chạy app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      // 2. Hành động: Nhấn nút '+' 2 lần liên tục
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pumpAndSettle();

      // Xác thực: Bộ đếm đã nhảy lên 2
      expect(find.text('2'), findsOneWidget);

      // 3. Hành động: Nhấn nút '-' 1 lần
      await tester.tap(find.text('-'));
      await tester.pumpAndSettle();

      // Xác thực: Bộ đếm giảm xuống còn 1
      expect(find.text('1'), findsOneWidget);
    });

    // ── TEST CASE 3: Luồng điều hướng khép kín giữa các màn hình ──
    // Mô tả: Giả lập quy trình người dùng đi từ HomeScreen -> DetailScreen -> HomeScreen
    // Kiểm tra xem việc quản lý chuyển trang của Navigator có hoạt động chính xác.
    testWidgets('Navigate Home → Detail → Home thành công',
        (WidgetTester tester) async {
      // 1. Chạy app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // 2. Hành động: Nhấn nút "Xem chi tiết" để chuyển màn hình
      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // Xác thực: Đã chuyển sang màn hình DetailScreen thành công
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.text('Bạn đã navigate thành công!'), findsOneWidget);

      // 3. Hành động: Nhấn nút "Quay lại" từ DetailScreen
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // Xác thực: Đã quay lại HomeScreen và DetailScreen đã bị huỷ
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(DetailScreen), findsNothing);
    });

    // ── TEST CASE 4: ⚠️ TEST CASE SAI CỐ Ý ĐỂ DEMO SỬA LỖI ──
    // Mô tả: Giả lập nhấn nút cộng (+) 3 lần (bộ đếm tăng lên 3), nhưng mong đợi là 5.
    // Lỗi này giúp người thuyết trình chỉ ra sự bắt lỗi của framework khi kết quả thực tế không khớp kỳ vọng.
    testWidgets('Counter hiển thị đúng sau khi nhấn + 3 lần',
        (WidgetTester tester) async {
      // 1. Chạy app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 2. Hành động: Nhấn nút '+' 3 lần
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pumpAndSettle();
      }

      // 3. ⚠️ BUG CỐ Ý: Nhấn 3 lần nhưng expect hiển thị số 5 -> Sẽ gây lỗi Test Failure!
      // Sửa lỗi: Cần thay đổi '5' thành '3' trong phần thuyết trình demo
      expect(find.text('5'), findsOneWidget);
    });
  });
}
