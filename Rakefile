require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "shnell"
    gem.summary = %Q{Server Setup and Configuration tools}
    gem.description = %Q{Ease Server Setup and Configuration}
    gem.email = "schmidt@netzmerk.com"
    gem.homepage = "http://github.com/jo/shnell"
    gem.authors = ["Johannes J. Schmidt"]
    gem.add_dependency "commander", ">= 4.0.2"
    gem.add_dependency "filander", ">= 0.5.3"
    gem.files = "{bin,lib}/**/*"
    gem.files << "VERSION"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "shnell #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
