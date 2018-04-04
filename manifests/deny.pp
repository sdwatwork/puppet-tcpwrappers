# Define tcpwrappers::deny

define tcpwrappers::deny (
  String                   $client = $title,
  String                   $daemon = 'ALL',
  Pattern[absent, present] $ensure = present,
  Optional[String]         $except = undef
) {
  tcpwrappers::entry { $name:
    ensure => $ensure,
    type   => 'deny',
    daemon => $daemon,
    client => $client,
    except => $except,
  }
}
