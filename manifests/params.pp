# Class: tcpwrappers::params
#
# This class defines default parameters used by the main module
# class tcpwrappers
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to tcpwrappers class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class tcpwrappers::params {

  $allow_file = $::operatingsystem ? {
    default => '/etc/hosts.allow',
  }

  $allow_source = ''
  $allow_template = ''

  $deny_file = $::operatingsystem ? {
    default => '/etc/hosts.deny',
  }

  $deny_template = ''
  $deny_source = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'libwrap0',
    default                   => 'setup',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $options = ''
  $version = 'present'
  $audit_only = false
  $noops = false

}
