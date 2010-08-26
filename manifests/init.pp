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
					source => "puppet://$server/asterisk/centos-asterisk.repo"
				}
				file { "/etc/yum.repos.d/centos-digium.repo" :
					ensure => present,
					owner => root,
					group => root,
					mode => 644,
					source => "puppet://$server/asterisk/centos-digium.repo"
				}				
# Install asterisk dependcies
				$asterisk_packages = ["asterisk$version", "asterisk$version-configs", "asterisk$version-voicemail", "dahdi-linux", "dahdi-tools", "libpri"]
				$mysql_packages = [ "mysql-server", "mysql" ]
				package { $asterisk_packages: ensure => installed }
				package { $mysql_packages: ensure => installed }
			}				
		}
	}

	class mysql_config ($root_password, $asterisk_db="asterisk", $asterisk_db_user="asterisk", $asterisk_db_password="redhat") {
		# Take root password and create the asterisk DB
		# Create the Asterisk Tables
		exec { "asterisk_db" :
			command => "mysql -u root -p$root_password -e 'CREATE DATABASE $asterisk_db; GRANT ALL PRIVILEGES ON $asterisk_db.* TO '$asterisk_db_user'@'localhost' IDENTIFIED BY '$asterisk_db_password' WITH GRANT OPTION;",
			path	=> "/usr/bin:/usr/sbin:/bin"
		}
}

}


