import 'package:chrome_extension/tabs.dart';
import 'package:chrome_extension/storage.dart';

class ChromeApi {
  // 현재 탭 정보 가져오기
  Future<Map<String, String>> getCurrentTab() async {
    final tabs = await chrome.tabs.query(
      QueryInfo(active: true, currentWindow: true),
    );

    if (tabs.isNotEmpty) {
      return {
        'title': tabs.first.title ?? 'No Title',
        'url': tabs.first.url ?? '',
      };
    }
    return {};
  }

  // 모든 북마크 가져오기
  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    try {
      // 라이브러리가 이미 Map<dynamic, dynamic>을 반환하므로 .toDart가 필요 없습니다.
      final Map<dynamic, dynamic> data = await chrome.storage.local.get('my_bookmarks');
      
      if (data.containsKey('my_bookmarks')) {
        final List<dynamic> rawList = data['my_bookmarks'];
        return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print("Error loading bookmarks: $e");
    }
    return [];
  }

  // 북마크 저장하기
  Future<void> saveBookmark(Map<String, String> newBookmark) async {
    try {
      List<Map<String, dynamic>> currentList = await getAllBookmarks();
      currentList.add(newBookmark);
      
      // 저장할 때도 라이브러리가 자동으로 처리를 도와줍니다.
      await chrome.storage.local.set({'my_bookmarks': currentList});
    } catch (e) {
      print("Error saving bookmark: $e");
    }
  }

  // 북마크 삭제하기
  Future<void> deleteBookmark(int index) async {
    try {
      List<Map<String, dynamic>> currentList = await getAllBookmarks();
      if (index >= 0 && index < currentList.length) {
        currentList.removeAt(index);
        await chrome.storage.local.set({'my_bookmarks': currentList});
      }
    } catch (e) {
      print("Error deleting bookmark: $e");
    }
  }
}