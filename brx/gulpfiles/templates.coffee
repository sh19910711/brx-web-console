do (group = "templates")->
  gulp = require("gulp")

  template_path = (target_path = "")->
    path = require("path")
    path.resolve path.join(__dirname, "../../lib/web_console/templates", target_path)

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

  gulp.task "#{group}/patch", ["templates/erb"], ->
    run = require("gulp-run")
    gulp.src ["patch/**/*.patch"]
      .pipe run("patch -p0")
