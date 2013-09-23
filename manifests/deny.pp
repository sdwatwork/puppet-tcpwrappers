# Define tcpwrappers::deny

define tcpwrappers::deny (
  $client = $title,
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
