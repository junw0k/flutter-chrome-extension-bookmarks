
window.flutterWebRenderer = "html";

window.getCurrentTabInfo = async function() {
  try {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    return {
      "title": tab.title,
      "url": tab.url,
      "favIconUrl": tab.favIconUrl
    };
  } catch (e) {
    console.error(e);
    return null;
  }
};