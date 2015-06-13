chrome.devtools.panels.create(
  "Rails Web Console"
  "img/icon_128.png"
  "html/panel.html"
  (panel)->
    console.log "panel = ", panel
)
