// ============================================================
//  NAVIGATION TEST — navigation_test.dart
//
//  Cấu trúc:
//  ┌─ Wrap app trong MaterialApp để có Navigator
//  ├─ pumpWidget(MaterialApp(...))   → Setup đầy đủ routing
//  ├─ tap + pumpAndSettle()          → Chờ animation kết thúc
//  │   (khác với pump() — dùng khi có page transition)
//  └─ expect(find.byType(Screen))    → Kiểm tra màn hình hiện tại
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_flutter_test/screens/home_screen.dart';
import 'package:demo_flutter_test/screens/detail_screen.dart';

void main() {
  group('Navigation Tests', () {
    // Helper: khởi tạo app đầy đủ với Navigator
    Widget buildApp() {
      return const MaterialApp(
        home: HomeScreen(),
      );
    }

    // ──────────────────────────────────────────────────────
    //  TEST 1: Navigate từ Home → Detail
    // ──────────────────────────────────────────────────────
    testWidgets('nhấn "Xem chi tiết" → mở DetailScreen',
        (WidgetTester tester) async {
      // ARRANGE: Render toàn bộ app
      await tester.pumpWidget(buildApp());

      // Xác nhận đang ở HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(DetailScreen), findsNothing);

      // ACT: Tap nút navigate
      await tester.tap(find.byKey(const Key('navigate_button')));

      // pumpAndSettle() → Chờ tất cả animation/transition hoàn tất
      // (khác pump(): pump chỉ trigger 1 frame, pumpAndSettle đợi đến khi idle)
      await tester.pumpAndSettle();

      // ASSERT: Đã chuyển sang DetailScreen
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.byKey(const Key('detail_title')), findsOneWidget);
      expect(find.text('Màn hình Chi tiết'), findsOneWidget);
    });

    // ──────────────────────────────────────────────────────
    //  TEST 2: Navigate back từ Detail → Home
    // ──────────────────────────────────────────────────────
    testWidgets('nhấn "Quay lại" → về HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Đến DetailScreen trước
      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // Xác nhận đang ở DetailScreen
      expect(find.byType(DetailScreen), findsOneWidget);

      // ACT: Nhấn nút quay lại
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // ASSERT: Đã về HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(DetailScreen), findsNothing);
    });

    // ──────────────────────────────────────────────────────
    //  TEST 3: Navigate bằng AppBar back button (system back)
    // ──────────────────────────────────────────────────────
    testWidgets('nhấn AppBar back button → về HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // Tìm nút back của AppBar (BackButton widget)
      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    // ──────────────────────────────────────────────────────
    //  TEST 4: Kiểm tra nội dung trên màn hình đích
    // ──────────────────────────────────────────────────────
    testWidgets('DetailScreen hiển thị đúng nội dung sau navigate',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('navigate_button')));
      await tester.pumpAndSettle();

      // Kiểm tra các element trên DetailScreen
      expect(find.text('Chi tiết'), findsOneWidget);           // AppBar title
      expect(find.text('Bạn đã navigate thành công!'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
