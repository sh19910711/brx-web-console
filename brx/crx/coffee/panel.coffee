sendCommand = (line, callback)->
  req =
    type: "send-command"
    tabId: chrome.devtools.inspectedWindow.tabId
    line: line
  chrome.runtime.sendMessage req, callback

commandHandle = (line)->
  sendCommand line, (response)=>
    @writeOutput response.output

getTabInfo = (tabId, callback)->
  req =
    type: "tab-info"
    tabId: tabId
  chrome.runtime.sendMessage req, callback

do ->
  tabId = chrome.devtools.inspectedWindow.tabId
  getTabInfo tabId, (tabInfo)->
    if tabInfo.sessionId
      remotePath = "#{tabInfo.remoteHost}console/repl_sessions/#{tabInfo.sessionId}"
      options =
        commandHandle: commandHandle
      REPLConsole.installInto "devtools-console", options
