# Define tcpwrappers::allow

define tcpwrappers::allow (
  String                   $client = $title,
  String                   $daemon = 'ALL',
  Pattern[absent, present] $ensure = present,
  Optional[String]         $except = undef
) {
  tcpwrappers::entry { $name:
    ensure => $ensure,
    type   => 'allow',
    daemon => $daemon,
    client => $client,
    except => $except,
  }
}
