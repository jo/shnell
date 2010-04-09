require 'yaml'

module Shnell
  module Config
    def db_user
      read_config(:db, :user)
    end

    def db_password
      read_config(:db, :password)
    end

    def db_credentials
      "-u#{db_user} #{"-p#{db_password}" if db_password != ''}"
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
end
