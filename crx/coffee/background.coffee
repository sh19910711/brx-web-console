tabInfo = {}

callback = (details)->
  res = response(details)
  if sessionId = res.headers["X-Web-Console-Session-Id"]
    console.log "bg: session-id: #{sessionId}"
    tabInfo[details.tabId] =
      sessionId: sessionId
      remoteHost: details.url

response = (details)->
  reduceFunc = (obj, headerInfo)->
    obj[headerInfo.name] = headerInfo.value
    obj

  method: details.method
  url: details.url
  headers: details.responseHeaders.reduce(reduceFunc, new Object)

filter =
  types: ["main_frame"]
  urls: [
    "http://*/*"
    "https://*/*"
  ]

extOpts = [
  "responseHeaders"
]

chrome.webRequest.onHeadersReceived.addListener(
  callback
  filter
  extOpts
)

chrome.runtime.onMessage.addListener (req, sender, sendResponse)->
  console.log "bg: onMessage: type = #{req.type}"
  if req.type == "send-command"
    info = tabInfo[req.tabId]
    url = "#{info.remoteHost}console/repl_sessions/#{info.sessionId}"
    params = "input=#{encodeURIComponent req.line}"
    console.log "bg: send command: #{req.line}"
    putRequest url, params, (xhr)->
      console.log "bg: send response(#{xhr.responseText})"
      sendResponse JSON.parse(xhr.responseText)
    return true
  else if req.type == "tab-info"
    console.log "bg: onMessage: tab-info(##{req.tabId})"
    info = tabInfo[req.tabId]
    unless typeof info.sessionId == undefined
      console.log "bg: response: sessionId=#{info.sessionId}"
      console.log "bg: response: remoteHost=#{info.remoteHost}"
      sendResponse info
      return true
  return false

