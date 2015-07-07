do (group = "build")->
  gulp = require("gulp")

  gulp.task group, [
    "crx"
  ]
