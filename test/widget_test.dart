import 'package:boardmap_project/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpApp(WidgetTester t) async {
    await t.binding.setSurfaceSize(const Size(400, 1800));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(const BoardMapApp());
  }

  Future<void> openSearch(WidgetTester t) async {
    await pumpApp(t);
    await t.binding.setSurfaceSize(const Size(500, 1800));
    await t.tap(find.text('Continue as guest'));
    await t.pumpAndSettle();
    await t.tap(find.text('Search'));
    await t.pumpAndSettle();
  }

  testWidgets('login screen renders its fields and actions', (t) async {
    await pumpApp(t);
    expect(find.text('Login to Your Account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('empty form shows validation errors', (t) async {
    await pumpApp(t);
    await t.tap(find.text('Login'));
    await t.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('invalid email is rejected', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.text('Login'));
    await t.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('valid login opens the home screen', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'leojnn@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.text('Login'));
    await t.pumpAndSettle(const Duration(seconds: 2));
    expect(find.textContaining(', Leojnn'), findsOneWidget);
    expect(find.text('Sunrise Boarding House'), findsOneWidget);
  });

  testWidgets('search shows loading, then success', (t) async {
    await openSearch(t);
    await t.tap(find.text('Search'));
    await t.pump();
    expect(find.text('Searching boarding houses...'), findsOneWidget);
    await t.pump(const Duration(seconds: 3));
    await t.pump();
    expect(find.text('Search completed'), findsOneWidget);
  });

  testWidgets('search shows an error with a retry button', (t) async {
    await openSearch(t);
    await t.tap(find.byType(Switch));
    await t.pump();
    await t.tap(find.text('Search'));
    await t.pump(const Duration(seconds: 3));
    await t.pump();
    expect(find.text('Search failed'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('search rejects a minimum price above the maximum', (t) async {
    await openSearch(t);
    await t.enterText(find.byType(TextFormField).at(0), '5000');
    await t.enterText(find.byType(TextFormField).at(1), '1000');
    await t.tap(find.text('Search'));
    await t.pump();
    expect(find.text('Minimum price cannot be higher than maximum'), findsOneWidget);
  });

  testWidgets('login shows loading, then success', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'leojnn@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.text('Login'));
    await t.pump();
    expect(find.text('Signing you in...'), findsOneWidget);
    await t.pump(const Duration(seconds: 2));
    await t.pump();
    expect(find.text('Login successful'), findsOneWidget);
    await t.pumpAndSettle(const Duration(seconds: 2));
  });

  testWidgets('login shows an error with a retry button', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'leojnn@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.byType(Switch));
    await t.pump();
    await t.tap(find.text('Login'));
    await t.pump(const Duration(seconds: 2));
    await t.pump();
    expect(find.text('Login failed'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}