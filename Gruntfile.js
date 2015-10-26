module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      sass: {
        files: ['_scss/*.{scss,sass}'],
        tasks: ['sass:dist']
      },
      coffee: {
        files: ['_coffee/*.coffee'],
        tasks: ['coffee:dist']
      },
      livereload: {
        files: [
          '*.php',
          'js/**/*.{js,json}',
          'css/*.css',
          'img/**/*.{png,jpg,jpeg,gif,webp,svg}'
        ],
        options: {
          livereload: true
        }
      }
    },
    sass: {
      dist: {
        files: [{
          expand: true,
          cwd: '_scss',
          src: '*.{scss,sass}',
          dest: 'css',
          ext: '.css'
        }]
      }
    },
    coffee: {
      dist: {
        files: [{
          expand: true,
          cwd: '_coffee',
          src: '**/*.coffee',
          dest: 'js',
          ext: '.js'
        }]
      }
    }
  });
  grunt.registerTask('default', ['sass:dist', 'coffee:dist', 'watch']);
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
};
