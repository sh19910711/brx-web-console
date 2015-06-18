sessionHash = {}

callback = (details)->
  res = response(details)
  if sessionId = res.headers["X-Web-Console"]
    sessionHash[details.tabId] = sessionId

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
  if req.type == "session-id"
    callback
      sessionId: sessionHash[req.tabId]

