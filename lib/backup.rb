require 'net/ftp'
require 'yaml'

module Backup
  include Filander

  class BackupScript
    class << self
      def backup(name, &block)
        backup = self.new(name)
        backup.prepare
        backup.instance_eval(&block)
        backup.backup!
        backup.finish
      end

      def restore(name, &block)
        backup = self.new(name)
        backup.instance_eval(&block)
        backup.restore!
        backup.finish
      end
    end

    def initialize(service)
      @service_root = service
      @service_name = File.basename(service)
      @database     = @service_name.gsub(/[-\.]/, '_')
      @tempdir      = File.join("/tmp", @service_name)
      @tarball      = "#{@tempdir}.tar.bz2"
      @directories  = []
      @databases    = []
    end

    def prepare
      backup_cmd "mkdir -p #{@tempdir}"
    end

    def directory(filename)
      report :directory, filename
      @directories << filename
    end

    def database(database = @database)
      report :database, database
      @databases << database
    end

    def backup!
      @directories.each do |filename|
        filename = File.join(@service_root, filename)
        backup_cmd "cp -r #{filename} #{@tempdir}/"
      end
      @databases.each do |database|
        backup_cmd "mysqldump -u#{db_user} #{"-p#{db_password}" if db_password != ''} #{database} > #{File.join(@tempdir, "#{database}.sql")}"
      end
      backup_cmd "tar -C /tmp -cjf #{@tarball} #{@service_name}"
      Net::FTP.open(ftp_host) do |ftp|
        ftp.login ftp_user, ftp_password
        ftp.putbinaryfile @tarball
      end
    end

    def restore!
      Net::FTP.open(ftp_host) do |ftp|
        ftp.login ftp_user, ftp_password
        ftp.getbinaryfile @tarball
      end
      backup_cmd "tar -C /tmp -xf #{@tarball}"
      @databases.each do |database|
        backup_cmd "mysql -u#{db_user} #{"-p#{db_password}" if db_password != ''} #{database} < #{File.join(@tempdir, "#{database}.sql")}"
      end
      @directories.each do |filename|
        source = File.join(@tempdir, filename)
        dest   = File.join(@service_root, filename)
        backup_cmd "cp -r #{source} #{dest}"
      end
    end

    def finish
      backup_cmd "rm -rf #{@tempdir}"
      backup_cmd "rm #{@tarball}"
    end

    private

    def backup_cmd(command)
      system command
    end

    def db_user
      read_config(:db, :user)
    end

    def db_password
      read_config(:db, :password)
    end

    def ftp_host
      read_config(:ftp, :host)
    end

    def ftp_user
      read_config(:ftp, :user)
    end

    def ftp_password
      read_config(:ftp, :password)
    end

    def read_config(scope, key)
      hash = config[scope.to_s] || {}
      value = hash[key.to_s]
      if value.nil?
        question = "Give me the #{scope} #{key}:"
        value = if key.to_s =~ /password/
                  ask(question) { |q| q.echo = "*" }
                else
                  ask(question)
                end
        write_config scope, key, value
      end
      value
    end

    def write_config(scope, key, value)
      hash = config
      hash[scope.to_s] ||= {}
      hash[scope.to_s].update key.to_s => value
      File.open(CONFIG_FILENAME, "w") do |file|
        file << YAML.dump(hash)
      end
    end

    def config
      content = File.read(CONFIG_FILENAME) rescue nil
      return {} unless content
      YAML.load(content)
    end
  end

  def backup(filename, &block)
    BackupScript.backup filename, &block
  end

  def restore(filename, &block)
    BackupScript.restore filename, &block
  end
end
