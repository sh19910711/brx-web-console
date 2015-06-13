callback = (details)->
  res = response(details)
  if sessionId = res.headers["X-Web-Console"]
    console.log "enabled?"

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
