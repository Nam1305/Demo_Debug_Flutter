// ============================================================
//  WIDGET TEST — counter_widget_test.dart
//
//  Cấu trúc:
//  ┌─ group('tên nhóm')          → Nhóm các test liên quan
//  │   ├─ testWidgets(...)        → Khai báo 1 test case
//  │   │   ├─ tester.pumpWidget  → Render widget vào virtual screen
//  │   │   ├─ find.xxx(...)      → Tìm kiếm widget
//  │   │   ├─ expect(...)        → Kiểm tra kết quả
//  │   │   ├─ tester.tap(...)    → Mô phỏng thao tác người dùng
//  │   │   └─ tester.pump()      → Trigger rebuild sau interaction
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_flutter_test/widgets/counter_widget.dart';

void main() {
  // ── Bước 1: Nhóm các test case liên quan với nhau ──
  group('CounterWidget', () {
    // ── Bước 2: Khai báo một test case ──
    testWidgets('hiển thị giá trị 0 khi mới khởi tạo',
        (WidgetTester tester) async {
      // ── ARRANGE: Render widget vào màn hình ảo ──
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      // ── ASSERT: Kiểm tra widget hiển thị đúng ──
      // find.text()   → Tìm widget có text khớp chính xác
      // find.byKey()  → Tìm widget theo Key
      // find.byType() → Tìm widget theo loại Widget
      expect(find.text('0'), findsOneWidget);
      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.text('Số đếm hiện tại:'), findsOneWidget);
    });

    testWidgets('tăng số đếm khi nhấn nút +', (WidgetTester tester) async {
      // ── ARRANGE ──
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      // ── Xác nhận trạng thái ban đầu ──
      expect(find.text('0'), findsOneWidget);

      // ── ACT: Mô phỏng người dùng nhấn nút ──
      await tester.tap(find.byKey(const Key('increment_button')));

      // pump() → Trigger Flutter rebuild (giống setState)
      await tester.pump();

      // ── ASSERT: Kiểm tra sau khi tương tác ──
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing); // số cũ không còn hiển thị
    });

    testWidgets('nhấn + nhiều lần tăng đúng số lần', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      // Nhấn nút + ba lần
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pump();
      }

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('nút - không giảm xuống dưới 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );

      // Nhấn - khi đang ở 0 → không được âm
      await tester.tap(find.text('-'));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });
  });
}
