do (group = "watch")->
  gulp = require("gulp")

  gulp.task group, [
    "crx"
  ].map (task)-> "#{group}/#{task}"

  gulp.task "#{group}/crx", ->
    gulp.watch [template_path "/**/*.erb"], ["crx/lib"]
    gulp.watch ["crx/coffee/**/*.coffee"], ["crx/coffee"]
    gulp.watch ["crx/manifest.json"], ["crx/manifest.json"]
    gulp.watch ["crx/html/**/*.html"], ["crx/html"]
