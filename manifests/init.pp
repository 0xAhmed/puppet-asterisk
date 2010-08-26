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
				package { $asterisk_packages: ensure => installed }
			}				
		}
	}
}
