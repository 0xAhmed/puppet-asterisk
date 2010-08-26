file { "/etc/yum.repos.d/centos-asterisk.repo" :
                 ensure => present,
                 owner => root,
                 group => root,
                mode => 644,
                source => "puppet:///centos-asterisk.repo"
              }
