glob = require("glob").sync

glob("./gulpfiles/*.coffee").forEach (path)->
  require path
