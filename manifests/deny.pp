# Define tcpwrappers::deny

define tcpwrappers::deny (
  $daemon,
  $client,
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
