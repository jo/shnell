module Shnell
  module Backup
    class << self
      attr_accessor :behavior
    end

    class BackupScript
      include Config
      include Ftp

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
        @directories << filename
      end

      def database(database = @database)
        @databases << database
      end

      def backup!
        @directories.each do |filename|
          report :directory, filename
          filename = File.join(@service_root, filename)
          backup_cmd "cp -r #{filename} #{@tempdir}/"
        end
        @databases.each do |database|
          report :database, database
          backup_cmd "mysqldump -u#{db_user} #{"-p#{db_password}" if db_password != ''} #{database} > #{File.join(@tempdir, "#{database}.sql")}"
        end
        backup_cmd "tar -C /tmp -cjf #{@tarball} #{@service_name}"
        ftp_put @tarball
      end

      def restore!
        ftp_get File.basename(@tarball), "/tmp" do
          backup_cmd "tar -C /tmp -xf #{@tarball}"
          @databases.each do |database|
            report :database, database
            backup_cmd "mysql -u#{db_user} #{"-p#{db_password}" if db_password != ''} #{database} < #{File.join(@tempdir, "#{database}.sql")}"
          end
          @directories.each do |filename|
            report :directory, filename
            source = File.join(@tempdir, filename)
            dest   = File.join(@service_root, filename)
            backup_cmd "cp -r #{source} #{dest}"
          end
        end
      end

      def finish
        backup_cmd "rm -rf #{@tempdir}" if File.exists?(@tempdir)
        backup_cmd "rm #{@tarball}" if File.exists?(@tarball)
      end

      private

      def backup_cmd(command)
        system command
      end
    end

    def service(filename, &block)
      if Backup.behavior == :restore
        restore filename, &block
      else
        backup filename, &block
      end
    end

    def backup(filename, &block)
      BackupScript.backup filename, &block
    end

    def restore(filename, &block)
      BackupScript.restore filename, &block
    end
  end
end
