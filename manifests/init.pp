class asterisk {
	class install ($version=14) {
		case $operatingsystem {
			"CentOS" : {
				# Setup Asterisk+Digium YUM Repos								
				yumrepo { "asterisk-current" :
					name => "CentOS-$releasever - Asterisk - Current",
					baseurl => "http://packages.asterisk.org/centos/$releasever/current/$basearch/",
					enabled => "1",
					gpgcheck => "0",
					#gpgkey => "http://packages.asterisk.org/RPM-GPG-KEY-Digium"
				}	
				yumrepo { "digium-current" :
					name => "CentOS-$releasever - Digium - Current",
					baseurl => "http://packages.digium.com/centos/$releasever/current/$basearch/",
					enabled => "1",
					gpgcheck => "0",
					#gpgkey => "http://packages.digium.com/RPM-GPG-KEY-Digium"
				}
				# Install asterisk dependcies
				$asterisk_packages = ["asterisk$version", "asterisk$version-configs", "asterisk$version-voicemail", "dahdi-linux", "dahdi-tools", "libpri"]
				package { $asterisk_packages: ensure => installed }
			}				
		}
	}
}
node "server1.example.com" {
	include asterisk::install
}
