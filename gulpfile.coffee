gulp = require("gulp")

do -> # lib
  gulp.task "lib/all", [
    "lib/templates"
  ]

  gulp.task "lib/templates", ->
    streamify = require("streamify")
    run    = require("gulp-run")
    concat = require("gulp-concat")
    rename = require("gulp-rename")
    gulp.src ["web-console/lib/web_console/templates/**/*.js.erb"]
      .pipe run("erb -r ./erb_helper", verbosity: 0)
      .pipe rename(extname: "")
      .pipe gulp.dest("dist/lib/")

do -> # build
  gulp.task "build", [
    "build/crx"
  ]

  gulp.task "build/crx", ["crx/all"]

do -> # watch
  gulp.task "watch", [
    "watch/crx"
  ]

  gulp.task "watch/crx", ->
    gulp.watch ["crx/coffee/**/*.coffee"], ["crx/coffee"]
    gulp.watch ["crx/manifest.json"], ["crx/manifest.json"]
    gulp.watch ["crx/html/**/*.html"], ["crx/html"]

do -> # crx
  gulp.task "crx/all", [
    "crx/manifest.json"
    "crx/lib"
    "crx/html"
    "crx/img"
    "crx/coffee"
    "crx/patch"
  ]

  gulp.task "crx/patch", ["crx/lib"], ->
    run = require("gulp-run")
    gulp.src ["patch/**/*.patch"]
      .pipe run("patch -p0")

  gulp.task "crx/coffee", ->
    coffee = require("gulp-coffee")
    gulp.src ["crx/coffee/**/*.coffee"]
      .pipe coffee()
      .pipe gulp.dest("dist/crx/js/")

  gulp.task "crx/img", ->
    gulp.src ["img/**/*.png"]
      .pipe gulp.dest("dist/crx/img/")

  gulp.task "crx/manifest.json", ->
    gulp.src ["crx/manifest.json"]
      .pipe gulp.dest("dist/crx/")

  gulp.task "crx/lib", ["lib/all"], ->
    gulp.src ["dist/lib/**/*.js"]
      .pipe gulp.dest("dist/crx/lib/")

  gulp.task "crx/html", ->
    gulp.src ["crx/html/**/*.html"]
      .pipe gulp.dest("dist/crx/html/")
