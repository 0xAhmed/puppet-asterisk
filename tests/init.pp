import "asterisk"
node 'server1.example.com' {
	include asterisk::install
	include asterisk::service
	class { asterisk::mysql_config: root_password =>  "redhat" }
}
