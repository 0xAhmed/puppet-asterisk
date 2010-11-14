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

class asterisk {
	include asterisk::install, asterisk::service, asterisk::mysql_config
}