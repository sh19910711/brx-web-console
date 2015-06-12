gulp = require("gulp")

gulp.task "templates", ->
  streamify = require("streamify")
  run    = require("gulp-run")
  concat = require("gulp-concat")
  rename = require("gulp-rename")
  gulp.src ["web-console/lib/web_console/templates/*.js.erb"]
    .pipe run("erb -r ./erb_helper", verbosity: 0)
    .pipe rename(extname: "")
    .pipe gulp.dest("dist/lib/")

