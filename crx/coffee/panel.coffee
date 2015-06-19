sendCommand = (line, sendCommandCallback)->
  req =
    type: "send-command"
    tabId: chrome.devtools.inspectedWindow.tabId
    line: line

  console.log "panel: before send command"
  chrome.runtime.sendMessage req, (res)->
    console.log "panel: after send-command"
    sendCommandCallback res
  setTimeout ->
    console.log "panel: check error = #{chrome.runtime.lastError}"

commandHandle = (line)->
  console.log "panel: command: #{line}"
  sendCommand line, (response)=>
    console.log "panel: result = #{response.output}"
    @writeOutput response.output

showConsole = ->
  req =
    type: "tab-info"
    tabId: chrome.devtools.inspectedWindow.tabId

  chrome.runtime.sendMessage req, (tabInfo)->
    console.log "panel: onResponse"
    if tabInfo.sessionId
      console.log "panel: onResponse: sessionId=#{tabInfo.sessionId}"
      console.log "panel: onResponse: remoteHost=#{tabInfo.remoteHost}"
      remotePath = "#{tabInfo.remoteHost}console/repl_sessions/#{tabInfo.sessionId}"
      options =
        commandHandle: commandHandle
      REPLConsole.installInto "devtools-console", options

showConsole()

