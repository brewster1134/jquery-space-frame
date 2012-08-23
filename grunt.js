/*global module:false*/
module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-haml');
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-sass');

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:spaceFrame.jquery.json>',
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', '<file_strip_banner:dist/<%= pkg.name %>.js.js>'],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    qunit: {
      files: ['test/**/*.html']
    },
    lint: {
      files: ['grunt.js', 'dist/**/*.js', 'demo/**/*.js', 'test/**/*.js']
    },
    watch: {
      files: ['<config:lint.files>', 'src/**/*'],
      tasks: 'coffee haml concat qunit' // sass
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        browser: true
      },
      globals: {
        jQuery: true
      }
    },
    uglify: {},
    coffee: {
      app: {
        src: 'src/spaceFrame.js.coffee',
        dest: 'dist',
        options: {},
        extension: ''
      },
      demo: {
        src: 'src/demo/demo.js.coffee',
        dest: 'demo',
        options: {},
        extension: ''
      },
      test: {
        src: 'src/test/test.js.coffee',
        dest: 'test',
        options: {},
        extension: ''
      }
    },
    haml: {
      demo: {
        src: "src/demo/index.html.haml",
        dest: "demo/index.html"
      },
      test: {
        src: "src/test/index.html.haml",
        dest: "test/index.html"
      }
    },
    sass: {
      app: {
        src: 'src/spaceFrame.css.sass',
        dest: 'dist/spaceFrame.css'
      },
      demo: {
        src: 'src/demo/demo.css.sass',
        dest: 'demo/demo.css'
      }
    }
  });

  // Default task.
  grunt.registerTask('default', 'dist');
  grunt.registerTask('dist', 'coffee:app concat min'); // sass:app
  grunt.registerTask('demo', 'dist coffee:demo haml:demo'); // sass:demo
  grunt.registerTask('test', 'dist coffee:test haml:test lint qunit'); // sass:demo

};
