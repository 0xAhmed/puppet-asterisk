class asterisk::install ($version=14) {
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

