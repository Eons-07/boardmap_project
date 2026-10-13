import 'package:boardmap_project/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpApp(WidgetTester t) async {
    await t.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(const BoardMapApp());
  }

  testWidgets('login screen renders its fields and actions', (t) async {
    await pumpApp(t);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('empty form shows validation errors', (t) async {
    await pumpApp(t);
    await t.tap(find.text('Sign In'));
    await t.pump();
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('invalid email is rejected', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.text('Sign In'));
    await t.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });

  testWidgets('valid login opens the home screen', (t) async {
    await pumpApp(t);
    await t.enterText(find.byType(TextFormField).at(0), 'leojnn@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'secret123');
    await t.tap(find.text('Sign In'));
    await t.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Hello, Leojnn'), findsOneWidget);
    expect(find.text('Sunrise Boarding House'), findsOneWidget);
  });

  testWidgets('home category filter narrows the list', (t) async {
    await pumpApp(t);
    await t.tap(find.text('Continue as guest'));
    await t.pumpAndSettle();
    await t.tap(find.text('Dorms'));
    await t.pumpAndSettle();
    expect(find.text('Scholars Dormitory'), findsOneWidget);
    expect(find.text('Sunrise Boarding House'), findsNothing);
  });
}