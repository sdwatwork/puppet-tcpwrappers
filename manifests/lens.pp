# Class tcpwrappers::lens
#
# This entry adds the lens for augeas.
# Requires augeas module.
#
class tcpwrappers::lens {

  include tcpwrappers

  file { 'tcpwrappers.lens':
    ensure  => present,
    path    => '/usr/share/augeas/lenses/tcpwrappers.aug',
    source  => 'puppet:///modules/tcpwrappers/augeas/tcpwrappers.aug',
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    require => Package[$::augeas::params::augeas_pkgs],
  }
}
