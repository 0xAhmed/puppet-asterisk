node 'server1.example.com' {
	include asterisk::install
	class { "asterisk::mysql_config" :
	root_password =>  "redhat"
  }
}
