# Class tcpwrappers::lens

class tcpwrappers::lens {

  include tcpwrappers

  file { 'augeas.lenses.dir':
    ensure  => directory,
    path    => '/usr/share/augeas/lenses/local',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package[$::augeas::params::augeas_pkgs],
  }

  file { 'tcpwrappers.lens':
    ensure  => present,
    path    => '/usr/share/augeas/lenses/local/tcpwrappers.aug',
    source  => 'puppet:///modules/tcpwrappers/augeas/tcpwrappers.aug',
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    require => File['augeas.lenses.dir'],
  }
}
