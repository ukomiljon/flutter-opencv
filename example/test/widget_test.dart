// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/core/imgproc.dart';

import 'package:opencv4_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
  });

  String url =
      "https://i.pinimg.com/564x/54/e2/ae/54e2aeefa75d031813ec56f6b3efc9ad.jpg";

  Image image = Image.asset('assets/temp.png');
}

Future loadImage(String url) async {
  File file = await DefaultCacheManager().getSingleFile(url);

  // var res = await ImgProc.blur(
  //     await file.readAsBytes(), [45, 45], [20, 30], Core.borderReflect);


}
