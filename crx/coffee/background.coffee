tabInfo = {}

callback = (details)->
  res = response(details)
  if sessionId = res.headers["X-Web-Console-Session-Id"]
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
  if req.type == "send-command"
    info = tabInfo[req.tabId]
    url = "#{info.remoteHost}console/repl_sessions/#{info.sessionId}"
    params = "input=#{encodeURIComponent req.line}"
    putRequest url, params, (xhr)->
      sendResponse JSON.parse(xhr.responseText)
    return true

  else if req.type == "tab-info"
    info = tabInfo[req.tabId]
    unless typeof info.sessionId == undefined
      sendResponse info
      return true

  return false
