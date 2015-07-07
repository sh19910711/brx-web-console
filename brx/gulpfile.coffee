global.template_path = (target_path = "")->
  path = require("path")
  path.resolve path.join(__dirname, "../lib/web_console/templates", target_path)

glob = require("glob").sync

glob("./gulpfiles/*.coffee").forEach (path)->
  require path
