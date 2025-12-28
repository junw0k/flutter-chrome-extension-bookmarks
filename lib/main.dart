import 'package:flutter/material.dart';
import 'chrome_api.dart'; // 방금 만든 API 파일 불러오기
import 'bookmark_list_page.dart';

void main() {
  runApp(const MyBookmarkApp());
}

class MyBookmarkApp extends StatelessWidget {
  const MyBookmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 띠 제거
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const BookmarkListPage(),
    );
  }
}