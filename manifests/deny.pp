# Define tcpwrappers::deny

define tcpwrappers::deny (
  $client,
  $daemon = 'ALL',
  $ensure = present,
  $except = undef
) {
  tcpwrappers::entry { $name:
    ensure => $ensure,
    type   => 'deny',
    daemon => $daemon,
    client => $client,
    except => $except,
  }
}
