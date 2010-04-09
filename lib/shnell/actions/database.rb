module Shnell
  module Database
    include Config
    include Filander::Base

    def create_database(name, user, password)
      report :create_db, name
      system "mysqladmin #{db_credentials} create #{name}"
      system "mysql #{db_credentials} -e \"GRANT ALL ON #{name}.* TO '#{user}'@'localhost' IDENTIFIED BY '#{password}'\""
    end
  end
end
