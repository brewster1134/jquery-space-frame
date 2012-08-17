COLOR_MAP = {
  coffee: :light_green,
  haml: :light_yellow
}

SRC_DIR =       File.join File.dirname(__FILE__), 'src'
COMPILED_DIR =  File.join(File.dirname(__FILE__), 'compiled')

# File type callbacks
def coffee file
  output_change __method__, file
  execute_shell_command "coffee -o #{COMPILED_DIR} -c #{file}"
end

def haml file
  output_change __method__, file
  execute_shell_command "haml #{file} #{COMPILED_DIR}/#{File.basename(file).sub(/\.haml$/, '')}"
end

def output_change type, file
  puts type.to_s.upcase.ljust(10).send(COLOR_MAP[type.to_sym]) + file
end

def execute_shell_command command
  `#{command} >& /dev/null`
end

task :watch do
  require 'listen'
  require 'colorize'

  puts ">>> WATCHING <<<".white.on_green
  puts

  listener = Listen.to(
    File.join(SRC_DIR, 'coffee'),
    File.join(SRC_DIR, 'haml')
  ) do |modified, added, removed|
    all = modified + added + removed
    all.each do |f|
      ext = File.extname(f).sub!(/^./, '').to_sym
      send ext, f
    end
  end
end
