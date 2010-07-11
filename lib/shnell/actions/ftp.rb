require 'net/ftp'

module Shnell::Actions
  module Ftp
    include Config
    include Filander::Base

    def ftp_get(filename, destination)
      return if Filander.behavior == :pretend
      inside destination do
        Net::FTP.open(ftp_host) do |ftp|
          ftp.login ftp_user, ftp_password
          ftp.getbinaryfile filename
        end
      end
      yield if block_given? && File.exists?(File.join(destination, filename))
    end

    def ftp_put(filename, destination = '/')
      return if Filander.behavior == :pretend
      Net::FTP.open(ftp_host) do |ftp|
        ftp.login ftp_user, ftp_password
        ftp.putbinaryfile File.join(destination, filename)
      end
    end
  end
end
