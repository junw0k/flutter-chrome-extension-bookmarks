import 'package:chrome_extension/tabs.dart';
import 'package:chrome_extension/storage.dart';

class ChromeApi {
  // 1. 현재 탭의 정보(제목, URL) 가져오기
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

  // 2. 내 세컨드 즐겨찾기에 저장하기 (chrome.storage 사용)
  Future<void> saveBookmark(Map<String, String> bookmark) async {
    // 기존 목록을 가져와서 새 항목 추가 로직 필요
    await chrome.storage.local.set({'my_bookmarks': bookmark});
  }
}