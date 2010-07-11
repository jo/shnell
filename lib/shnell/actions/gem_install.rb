module Shnell::Actions
  module GemInstall
    include Filander::Base

    def gem_install(name, version = nil)
      if version
        gem_install_args = "-v=#{version} #{name}"
        report_name = "#{name} #{version}"
      else
        gem_install_args = name
        report_name = name
      end
      if gem_exists?(name, version)
        report :installed, 'gem %s' % report_name
      else
        report :install, 'gem %s' % report_name
        unless Filander.behavior == :pretend
          system "gem install #{gem_install_args}"
        end
      end
    end
    alias :install_gem :gem_install

    private

    def gem_exists?(name, version)
      Gem.path.map { |p| File.join(p, 'gems', "#{name}-#{version || '*'}") }.any? { |p| Dir[p].size > 0 }
    end
  end
end
