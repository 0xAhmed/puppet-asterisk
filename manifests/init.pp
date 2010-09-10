class asterisk {
	class install ($version=14) {
		case $operatingsystem {
			"CentOS" : {
				# Installing Asterisk+Digium YUM Repos								
				file { "/etc/yum.repos.d/centos-asterisk.repo" :
					ensure => present,
					owner => root,
					group => root,
					mode => 644,
					source => "puppet://$server/asterisk/centos-asterisk.repo",
					before => Package["$asterisk_packages"]
				}
				file { "/etc/yum.repos.d/centos-digium.repo" :
					ensure => present,
					owner => root,
					group => root,
					mode => 644,
					source => "puppet://$server/asterisk/centos-digium.repo",
					before => Package["$asterisk_packages"]
				}				
				
				# Install asterisk dependcies
				$asterisk_packages = ["asterisk$version", "asterisk$version-configs", "asterisk$version-addons-mysql"]
				$mysql_packages = [ "mysql-server", "mysql" ]
				package { $asterisk_packages: ensure => installed }
				package { $mysql_packages: ensure => installed }
			}				
		}

		service { "asterisk":
			enable => true,
			ensure => running,
			hasrestart => "true",
			hasstatus => "true",
			require	=> Package["$asterisk_pacakges"],
			alias => "asterisk"
		}

		
	}

	class mysql_config ($root_password, $asterisk_db="asterisk", $asterisk_db_user="asterisk", $asterisk_db_password="redhat") {
		# Take root password and create the asterisk DB
		# Create the Asterisk Tables
		exec { "create_asterisk_db" :
			command => "mysql -u root -p$root_password -e 'CREATE DATABASE $asterisk_db; GRANT ALL PRIVILEGES ON $asterisk_db.* TO '$asterisk_db_user'@'localhost' IDENTIFIED BY \"$asterisk_db_password\" WITH GRANT OPTION;'",
			path	=> "/usr/bin:/usr/sbin:/bin",
#			require => Class["install"],
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
#			notify => Service["asterisk"]
		}

		

}
}

