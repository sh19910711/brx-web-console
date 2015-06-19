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

chrome.runtime.onMessage.addListener (req, sender, callback)->
  console.log "bg: onMessage"
  if req.type == "tab-info"
    console.log "bg: onMessage: tab-info(##{req.tabId})"
    info = tabInfo[req.tabId]
    unless typeof info.sessionId == undefined
      console.log "bg: response: sessionId=#{info.sessionId}"
      console.log "bg: response: remoteHost=#{info.remoteHost}"
      callback info

