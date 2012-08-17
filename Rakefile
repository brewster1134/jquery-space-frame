COLOR_MAP = {
  coffee: :light_green,
  haml: :light_yellow,
  sass: :light_blue
}

SRC_DIR =       File.join File.dirname(__FILE__), 'src'
COMPILED_DIR =  File.join(File.dirname(__FILE__), 'compiled')


# File type callbacks
def coffee file
  output_change __method__, file
  execute_shell_command "coffee -o #{File.dirname(get_compiled_path(file))} -c #{file}"

  # rename annoying .js.js extensions
  name = File.basename(file).sub(/\.coffee/, '')
  execute_shell_command "mv #{get_compiled_path(file)}.js #{get_compiled_path(file)}"
end

def haml file
  output_change __method__, file
  execute_shell_command "haml #{file} #{get_compiled_path file}"
end

def sass file
  output_change __method__, file
  execute_shell_command "sass #{file} #{get_compiled_path file}"
end


def get_compiled_path file
  ext = File.extname(file)
  COMPILED_DIR + file.sub(SRC_DIR + '/' + ext[1..-1], '').chomp(ext)
end

def output_change type, file
  puts type.to_s.upcase.ljust(10).send(COLOR_MAP[type.to_sym]) + file.sub(SRC_DIR, '')
end

def execute_shell_command command
  # `#{command} >& /dev/null`
  `#{command}`
end

task :watch do
  require 'listen'
  require 'colorize'

  puts ">>> WATCHING <<<".white.on_green
  puts

  listener = Listen.to(
    File.join(SRC_DIR, 'coffee'),
    File.join(SRC_DIR, 'haml'),
    File.join(SRC_DIR, 'sass'),
  ) do |modified, added, removed|
    all = modified + added + removed
    all.each do |f|
      ext = File.extname(f).sub!(/^./, '').to_sym
      send ext, f
    end
  end
end
