import 'package:flutter/material.dart';
import 'bookmark_list_page.dart';

void main() {
  runApp(const ShadowBookmarkApp());
}

class ShadowBookmarkApp extends StatelessWidget {
  const ShadowBookmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Marks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const BookmarkListPage(),
    );
  }
}