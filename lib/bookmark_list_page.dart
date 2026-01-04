import 'package:flutter/material.dart';
import 'chrome_api.dart';

class BookmarkListPage extends StatefulWidget {
  const BookmarkListPage({super.key});

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  final ChromeApi _api = ChromeApi();
  final TextEditingController _titleController = TextEditingController();
  List<Map<String, dynamic>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _refreshList(); // 앱 시작 시 저장된 데이터 로드
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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

  void _showAddDialog() async{
    final currentTab = await _api.getCurrentTab();
    _titleController.text = currentTab['title'] ?? '';

    if (!mounted) return;
    // 다이얼로그 띄우기
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white, // 다이얼로그 배경 흰색
        title: const Text('북마크 추가'),
        content: TextField(
          controller: _titleController, // 컨트롤러 연결
          decoration: const InputDecoration(
            labelText: '제목을 입력하세요',
            hintText: '예: 내 블로그',
          ),
          autofocus: true, // 창 뜨자마자 키보드 활성화
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
          ElevatedButton(
            onPressed: () async {
              final newTitle = _titleController.text; // 사용자가 수정한 제목
              if (newTitle.isNotEmpty) {
                // 사용자가 입력한 제목과 실제 URL을 매칭하여 저장
                await _api.saveBookmark({
                  'title': newTitle,
                  'url': currentTab['url'] ?? '',
                });
                Navigator.pop(ctx); // 창 닫기
                _refreshList(); // 목록 새로고침
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Shadow Marks'),
        elevation: 0,
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
        backgroundColor: Colors.indigo,
        onPressed: _showAddDialog,
        tooltip: '현재 탭 저장',
        child: const Icon(Icons.add),
      ),
    );
  }
}