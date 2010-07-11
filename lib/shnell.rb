require 'filander'
require 'shnell/config'
require 'shnell/actions/ftp'
require 'shnell/actions/database'
require 'shnell/actions/gem_install'
require 'shnell/actions/git_clone'
require 'shnell/backup'

module Shnell
  include Config
  include Filander
  include Actions::Ftp
  include Actions::Database
  include Actions::GemInstall
  include Actions::GitClone
  include Backup

  class << self
    def behavior=(value)
      Filander.behavior = value
      Backup.behavior = value
    end

    def quiet=(value)
      Filander.quiet = value
    end

    def source_root=(value)
      Filander.source_root = value
    end
  end
end
