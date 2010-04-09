require 'filander'
require 'shnell/config'
require 'shnell/actions/ftp'
require 'shnell/backup'

module Shnell
  include Config
  include Filander
  include Ftp
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
