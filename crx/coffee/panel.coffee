req =
  type: "tab-info"
  tabId: chrome.devtools.inspectedWindow.tabId

console.log "panel: sendRequest"
chrome.runtime.sendMessage req, (tabInfo)->
  console.log "panel: onResponse"
  if tabInfo.sessionId
    console.log "panel: onResponse: sessionId=#{tabInfo.sessionId}"
    console.log "panel: onResponse: remoteHost=#{tabInfo.remoteHost}"
    remotePath = "#{tabInfo.remoteHost}console/repl_sessions/#{tabInfo.sessionId}"
    console.log "panel: remotePath=#{remotePath}"
    options =
      remotePath: remotePath
    REPLConsole.installInto "devtools-console", options
