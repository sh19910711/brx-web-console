sendCommand = (line, callback)->
  req =
    type: "send-command"
    tabId: chrome.devtools.inspectedWindow.tabId
    line: line
  chrome.runtime.sendMessage req, callback

commandHandle = (line)->
  sendCommand line, (response)=>
    @writeOutput response.output

do ->
  req =
    type: "tab-info"
    tabId: chrome.devtools.inspectedWindow.tabId
  chrome.runtime.sendMessage req, (tabInfo)->
    if tabInfo.sessionId
      remotePath = "#{tabInfo.remoteHost}console/repl_sessions/#{tabInfo.sessionId}"
      options =
        commandHandle: commandHandle
      REPLConsole.installInto "devtools-console", options
