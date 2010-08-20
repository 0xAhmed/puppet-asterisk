class asterisk {
	class install {
			case $operatingsystem {
				"CentOS" : {
					case $architecture {
						"i386" : {
							class download {
								# Install asterisk dependcies
								#$asterisk_packages_32 = []
								#package { $asterisk_packges_32: ensure => installed }
						
								# Create /usr/src/asterisk dir to hold asterisk sources
								file { "/usr/src/asterisk" :
									ensure => directory,
									owner => root,
									group => root,
									mode => 644
								}

								# Download asterisk sources
								exec { "wget http://downloads.digium.com/pub/asterisk/asterisk-1.4-current.tar.gz" :
									cwd => "/usr/src/asterisk",
									creates => "/usr/src/asterisk/asterisk-1.4-current.tar.gz",
									path => "/usr/bin:/usr/sbin:/bin",
									alias => "download-asterisk"
								}

            		# Download dahdi sources
            		exec { "wget http://downloads.digium.com/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz" :
              		cwd => "/usr/src/asterisk",
              		creates => "/usr/src/asterisk/dahdi-linux-complete-current.tar.gz",
									path => "/usr/bin:/usr/sbin:/bin",
									alias => "download-dahdi"
            		}

            		# Download libpri sources
            		exec { "wget http://downloads.digium.com/pub/libpri/libpri-1.4-current.tar.gz" :
              		cwd => "/usr/src/asterisk",
              		creates => "/usr/src/asterisk/libpri-1.4-current.tar.gz",
									path => "/usr/bin:/usr/sbin:/bin",
									alias => "download-libpri"
								}

            		# Download and spandsp sources
            		exec { "wget http://soft-switch.org/downloads/spandsp/spandsp-0.0.5.tgz" :
              		cwd => "/usr/src/asterisk",
              		creates => "/usr/src/asterisk/spandsp-0.0.5.tgz",
									path => "/usr/bin:/usr/sbin:/bin",
									alias => "download-spandsp"
            		}
							}

							# Untar sources, configure and make
							class configure {
            		class spandsp {
									exec { "tar -zxf spandsp-0.0.5.tgz" :
              			cwd => "/usr/src/asterisk",
              			require => Exec["download-spandsp"],
										path => "/usr/bin:/usr/sbin:/bin",
										creates => "/usr/src/asterisk/spandsp",
										alias => "untar-spandsp"
            			}
		
									exec { "make clean && ./configure" :
										cwd => "/usr/src/asterisk/spandsp",
										path => "/usr/bin:/usr/sbin:/bin",
										require => Exec["untar-spandsp"],
										alias => "configure-spandsp"	

									}		

									exec { "make && make install" :
										cwd => "/usr/src/asterisk/spandsp",
                    path => "/usr/bin:/usr/sbin:/bin",
 	                  require => Exec["configure-spandsp"]
									}	
								

									file { "/etc/ld.so.conf.d/spandsp.conf" : 
										ensure => present,
										source => "puppet:///spandsp.conf"
									}
			
									exec { "ldconfig -v" :
										path => "/usr/bin:/usr/sbin:/bin",
										require => File["/etc/ld.so.conf.d/spandsp.conf"]
									}
								}
							
								class libpri {
									exec { "make clean" :
										cwd => "/usr/src/asterisk/libpri",
										path => "/usr/bin:/usr/sbin:/bin",
										require => Exec["download-libpri"] 
									}
					
									exec { "make && make install" :
										cwd => "/usr/src/asterisk/libpri",
										path => "/usr/bin:/usr/sbin:/bin",
									}
								}
						}
					}
				}
			}

}
}
}
node "server1.example.com" {
	include asterisk::install::download
	include asterisk::install::configure::spandsp
	include asterisk::install::configure::libpri
}
#                 exec { "tar -zxf asterisk-1.4-current.tar.gz" :
#                   cwd => "/usr/src/asterisk",
#                   require => Exec["download-asterisk"],
#                   path => "/usr/bin:/usr/sbin:/bin"
#                 }
# 
#                 exec { "tar -zxf dahdi-linux-complete-current.tar.gz" :
#                   cwd => "/usr/src/asterisk",
#                   require => Exec["download-dahdi"],
#                   path => "/usr/bin:/usr/sbin:/bin"
#                 }
