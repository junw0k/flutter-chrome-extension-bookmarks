import 'package:flutter/material.dart';
import 'chrome_api.dart';

class BookmarkListPage extends StatefulWidget {
  const BookmarkListPage({super.key});

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  final ChromeApi _api = ChromeApi();
  List<Map<String, String>> _bookmarks = [];

  // 현재 페이지 추가 로직
  Future<void> _addNewBookmark() async {
    final newTab = await _api.getCurrentTab();
    if (newTab.isNotEmpty) {
      setState(() {
        _bookmarks.add(newTab);
      });
      // 실제 제품이라면 여기서 chrome.storage에도 저장해야 합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Second Bookmarks')),
      body: _bookmarks.isEmpty 
        ? const Center(child: Text('저장된 즐겨찾기가 없습니다.'))
        : ListView.builder(
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.bookmark),
                title: Text(_bookmarks[index]['title'] ?? ''),
                subtitle: Text(_bookmarks[index]['url'] ?? ''),
                onTap: () => /* URL 열기 로직 */ {},
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBookmark,
        child: const Icon(Icons.add_link),
      ),
    );
  }
}