# Class: asterisk-realtime
#
# This module installs and configures Asterisk in real time mode
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
import "install.pp"
import "mysql_config.pp"
class asterisk {
	include asterisk::install
	include asterisk::mysql_config
}