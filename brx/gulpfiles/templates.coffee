do (group = "templates")->
  gulp = require("gulp")

  gulp.task group, [
    "erb"
    "patch"
  ].map (task)-> "#{group}/#{task}"

  gulp.task "#{group}/erb", ->
    run = require("gulp-run")
    rename = require("gulp-rename")
    gulp.src [template_path "**/*.js.erb"]
      .pipe run("bundle exec erb -r ./erb_helper", verbosity: 0)
      .pipe rename(extname: "")
      .pipe gulp.dest("tmp/templates")

  gulp.task "#{group}/patch", ["#{group}/erb"], ->
    run = require("gulp-run")
    gulp.src ["patch/**/*.patch"]
      .pipe run("patch -p0")
