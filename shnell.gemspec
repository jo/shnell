# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shnell}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Johannes J. Schmidt"]
  s.date = %q{2010-04-08}
  s.default_executable = %q{shnell}
  s.description = %q{Ease Server Setup and Configuration}
  s.email = %q{schmidt@netzmerk.com}
  s.executables = ["shnell"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "bin/shnell",
     "lib/shnell.rb",
     "shnell.gemspec"
  ]
  s.homepage = %q{http://github.com/jo/shnell}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Server Setup and Configuration tools}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, [">= 4.0.2"])
      s.add_runtime_dependency(%q<filander>, [">= 0.2.0"])
    else
      s.add_dependency(%q<commander>, [">= 4.0.2"])
      s.add_dependency(%q<filander>, [">= 0.2.0"])
    end
  else
    s.add_dependency(%q<commander>, [">= 4.0.2"])
    s.add_dependency(%q<filander>, [">= 0.2.0"])
  end
end

