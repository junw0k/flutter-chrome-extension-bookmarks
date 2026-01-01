import 'package:flutter/material.dart';
import 'chrome_api.dart';

class BookmarkListPage extends StatefulWidget {
  const BookmarkListPage({super.key});

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  final ChromeApi _api = ChromeApi();
  List<Map<String, dynamic>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _refreshList(); // 앱 시작 시 저장된 데이터 로드
  }

  // 목록 새로고침 로직
  Future<void> _refreshList() async {
    final data = await _api.getAllBookmarks();
    setState(() {
      _bookmarks = data;
    });
  }

  // 저장 버튼 클릭 시 로직
  Future<void> _onAddBookmark() async {
    final currentTab = await _api.getCurrentTab();
    if (currentTab.isNotEmpty) {
      await _api.saveBookmark(currentTab);
      await _refreshList(); // 저장 후 목록 업데이트
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('현재 페이지가 저장되었습니다!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shadow Marks'),
        elevation: 2,
      ),
      body: _bookmarks.isEmpty
          ? const Center(child: Text('저장된 링크가 없습니다.'))
          : ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final item = _bookmarks[index];
                return ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: Text(item['title'] ?? 'No Title', maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(item['url'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  
                  onTap: () async {
                    final String? url = item['url'];
                    if (url != null && url.isNotEmpty) {
                      await _api.openUrl(url); // 새 탭 열기 호출
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: ()  {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('삭제 확인'),
                          content: const Text('이 북마크를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _api.deleteBookmark(index);
                                _refreshList();
                              },
                              child: const Text(
                                '삭제',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                      
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddBookmark,
        tooltip: '현재 탭 저장',
        child: const Icon(Icons.add),
      ),
    );
  }
}