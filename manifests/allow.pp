# Define tcpwrappers::allow

define tcpwrappers::allow (
  $client = $title,
  $daemon = 'ALL',
  $ensure = present,
  $except = undef
) {
  tcpwrappers::entry { $name:
    ensure => $ensure,
    type   => 'allow',
    daemon => $daemon,
    client => $client,
    except => $except,
  }
}
