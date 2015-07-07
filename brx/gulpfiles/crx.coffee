do (group = "crx")->
  gulp = require("gulp")

  destpath = (path = "")->
    "dist/crx/#{path}"

  gulp.task group, [
    "coffee"
    "html"
    "img"
    "lib"
    "manifest.json"
  ].map (task)-> "#{group}/#{task}"

  gulp.task "#{group}/coffee", ->
    coffee = require("gulp-coffee")
    gulp.src ["crx/coffee/**/*.coffee"]
      .pipe coffee()
      .pipe gulp.dest(destpath "js/")

  gulp.task "#{group}/img", ->
    gulp.src ["img/**/*.png"]
      .pipe gulp.dest(destpath "img/")

  gulp.task "#{group}/manifest.json", ->
    gulp.src ["crx/manifest.json"]
      .pipe gulp.dest(destpath "")

  gulp.task "#{group}/lib", [
    "templates"
  ].map (task)-> "#{group}/lib/#{task}"

  gulp.task "#{group}/lib/templates", ["templates"], ->
    gulp.src ["tmp/templates/**/*.js"]
      .pipe gulp.dest(destpath "lib/")

  gulp.task "#{group}/html", ->
    gulp.src ["crx/html/**/*.html"]
      .pipe gulp.dest(destpath "html/")
