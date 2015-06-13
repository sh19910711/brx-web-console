req =
  type: "session-id"
  tabId: chrome.devtools.inspectedWindow.tabId

chrome.runtime.sendMessage req, (res)->
  if sessionId = res.sessionId
    REPLConsole.installInto "console"
