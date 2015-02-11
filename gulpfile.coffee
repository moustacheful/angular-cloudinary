gulp = require 'gulp'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
rename = require 'gulp-rename'
plumber = require 'gulp-plumber'
uglify = require 'gulp-uglify'
notify = require 'gulp-notify'
concat = require 'gulp-concat'

paths =
	bower: './bower_components'
	dev: './src'
	dist: './dist'

gulp.task 'watch', ->
	watch paths.dev + '/**/*.coffee', (files) -> gulp.start('build:coffee')


gulp.task 'build:coffee', ->
	gulp.src([
		paths.dev + 'Cloudinary.coffee',
		paths.dev + '/modules/**/*.coffee'
	])
	.pipe(plumber())
	.pipe(concat('Cloudinary.js'))
	.pipe(coffee())
	.pipe(gulp.dest(paths.dist))
	.pipe(notify('Coffee compiled'))