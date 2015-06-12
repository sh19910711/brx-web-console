gulp = require("gulp")

gulp.task "templates", ->
  streamify = require("streamify")
  run    = require("gulp-run")
  concat = require("gulp-concat")
  rename = require("gulp-rename")
  gulp.src ["web-console/lib/web_console/templates/**/*.js.erb"]
    .pipe run("erb -r ./erb_helper", verbosity: 0)
    .pipe rename(extname: "")
    .pipe gulp.dest("dist/lib/")

gulp.task "build", [
  "build/crx"
]

gulp.task "build/crx", ["crx/all"]

do -> # crx
  gulp.task "crx/all", [
    "crx/manifest.json"
    "crx/lib"
  ]

  gulp.task "crx/manifest.json", ->
    gulp.src ["crx/manifest.json"]
      .pipe gulp.dest("dist/crx/")

  gulp.task "crx/lib", ["templates"], ->
    gulp.src ["dist/lib/**/*.js"]
      .pipe gulp.dest("dist/crx/lib/")

