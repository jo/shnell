module Shnell::Actions
  module GitClone
    include Filander::Base

    def git_clone(repository, destination)
      report :clone, repository
      unless Filander.behavior == :pretend
        system "git clone #{repository} #{join_destination(destination)}"
      end
    end
  end
end
