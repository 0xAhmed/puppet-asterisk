class asterisk::mysql_config ($root_password, $asterisk_db="asterisk", $asterisk_db_user="asterisk", $asterisk_db_password="redhat") {
		# Take root password and create the asterisk DB
		# Create the Asterisk Tables
		exec { "create_asterisk_db" :
			command => "mysql -u root -p$root_password -e 'CREATE DATABASE $asterisk_db; GRANT ALL PRIVILEGES ON $asterisk_db.* TO '$asterisk_db_user'@'localhost' IDENTIFIED BY \"$asterisk_db_password\" WITH GRANT OPTION;'",
			path	=> "/usr/bin:/usr/sbin:/bin",
			require => Class["asterisk::install"],
			before => Exec["import_database"]
		}

		file { "/var/lib/mysql/asterisk.sql":
			owner	=>	mysql,
			group => 	mysql,
			mode	=> 600,
			content => template("asterisk/asterisk.sql.erb")
		}

		file { "/etc/asterisk/res_mysql.conf":
			owner	=> asterisk,
			group	=> asterisk,
			mode => 664,
			content	=> template("asterisk/res_mysql.conf.erb")
		}

		file { "/etc/asterisk/extconfig.conf":
			owner	=> asterisk,
			group	=> asterisk,
			mode => 664,
			content	=> template("asterisk/extconfig.conf.erb")
		}

		exec { "import_database" :
			cwd => "/var/lib/mysql",
			command => "mysql -u root -p$root_password $asterisk_db < asterisk.sql",
			path => "/usr/bin:/usr/sbin:/bin",
			require => File["/var/lib/mysql/asterisk.sql"],
			notify => Class["asterisk::service"]
		}
		
}
