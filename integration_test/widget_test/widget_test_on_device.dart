// ============================================================
//  WIDGET TEST (chạy trên thiết bị) — widget_test_on_device.dart
//
//  Giống Widget Test gốc nhưng chạy trên thiết bị thật
//  bằng cách dùng IntegrationTestWidgetsFlutterBinding
//  → Có thể nhìn thấy test chạy trên màn hình app
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_flutter_test/widgets/counter_widget.dart';

void main() {
  // Bắt buộc: Khởi tạo binding để chạy kiểm thử giao diện trực tiếp trên màn hình thiết bị
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CounterWidget - On Device', () {
    
    // ── TEST CASE 1: Kiểm thử giá trị khởi tạo của CounterWidget ──
    // Mô tả: Đảm bảo khi CounterWidget vừa được render lên màn hình, 
    // giá trị mặc định được hiển thị phải là số 0 và có nhãn chữ tương ứng.
    testWidgets('hiển thị giá trị 0 khi mới khởi tạo',
        (WidgetTester tester) async {
      // 1. Render CounterWidget vào màn hình thiết bị thật/giả lập
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      // Chờ giao diện render hoàn tất
      await tester.pumpAndSettle();

      // 2. Xác thực kết quả hiển thị trên màn hình
      expect(find.text('0'), findsOneWidget); // Phải tìm thấy chính xác một widget hiển thị text "0"
      expect(find.byKey(const Key('counter_text')), findsOneWidget); // Kiểm tra widget đếm có Key đúng
      expect(find.text('Số đếm hiện tại:'), findsOneWidget); // Kiểm tra nhãn mô tả
    });

    // ── TEST CASE 2: Kiểm thử hành động nhấn nút cộng (+) ──
    // Mô tả: Giả lập nhấn nút cộng (+) một lần và kiểm tra xem số đếm
    // có tăng từ 0 lên 1 hay không.
    testWidgets('tăng số đếm khi nhấn nút +', (WidgetTester tester) async {
      // 1. Khởi chạy Widget
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      await tester.pumpAndSettle();

      // Kiểm tra giá trị bắt đầu phải là 0
      expect(find.text('0'), findsOneWidget);

      // 2. Thực hiện hành động: Tìm và nhấn nút '+' theo Key
      await tester.tap(find.byKey(const Key('increment_button')));
      // Chờ rebuild giao diện sau khi nhấn nút
      await tester.pumpAndSettle();

      // 3. Xác thực: Giá trị mới phải là 1, và giá trị cũ (0) không còn hiển thị
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    // ── TEST CASE 3: Kiểm thử nhấn nút cộng (+) nhiều lần liên tục ──
    // Mô tả: Giả lập vòng lặp nhấn nút cộng (+) 3 lần liên tiếp và kiểm tra
    // xem số đếm có tăng chính xác lên 3 hay không.
    testWidgets('nhấn + nhiều lần tăng đúng số lần',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      await tester.pumpAndSettle();

      // Vòng lặp nhấn nút '+' 3 lần
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pumpAndSettle();
      }

      // Xác thực: Số đếm cuối cùng hiển thị trên màn hình phải là 3
      expect(find.text('3'), findsOneWidget);
    });

    // ── TEST CASE 4: Kiểm thử giới hạn dưới của bộ đếm (không âm) ──
    // Mô tả: Nhấn nút trừ (-) khi số đếm đang ở mức 0 và đảm bảo
    // bộ đếm không bị giảm xuống số âm (nhỏ hơn 0).
    testWidgets('nút - không giảm xuống dưới 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      await tester.pumpAndSettle();

      // Thực hiện hành động: Nhấn nút trừ '-' khi bộ đếm đang là 0
      await tester.tap(find.text('-'));
      await tester.pumpAndSettle();

      // Xác thực: Bộ đếm vẫn phải giữ nguyên là 0, không được âm
      expect(find.text('0'), findsOneWidget);
    });
  });
}
