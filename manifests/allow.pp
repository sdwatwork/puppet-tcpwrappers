class tcpwrappers::lens {
	file { "/usr/share/augeas/lenses/tcpwrappers.aug":
		source => "puppet:///tcpwrappers/usr/share/augeas/lenses/tcpwrappers.aug",
		mode   => 0444;
	}
}

define tcpwrappers::allow($daemon, $client, $ensure = present) {
	include tcpwrappers::lens

	Augeas {
		context => "/files/etc/hosts.allow",
		require => File["/usr/share/augeas/lenses/tcpwrappers.aug"],
	}

	# Parse the client spec.
	#
	# Never use masklen -- the access control language only supports that on
	# IPv6 addresses (!), which we're not attempting to handle here. If the
	# caller passes n.n.n.n/l, convert it to n., n.n., n.n.n., or
	# n.n.n.n/m.m.m.m.
	case $client {
		/^\.[a-z\d.]+$/: {
			$c = $client
			$nm = undef
		}
		/^(\d+\.)(\d+\.\d+\.\d+\/(8|255\.0\.0\.0))?$/: {
			$c = $1
			$nm = undef
		}
		/^(\d+\.\d+\.)(\d+\.\d+\/(16|255\.255\.0\.0))?$/: {
			$c = $1
			$nm = undef
		}
		/^(\d+\.\d+\.\d+\.)(\d+\/(24|255\.255\.255\.0))?$/: {
			$c = $1
			$nm = undef
		}
		/^(\d+\.\d+\.\d+\.\d+)(\/(32|255\.255\.255\.255))?$/: {
			$c = $1
			$nm = undef
		}
		/^(\d+\.\d+\.\d+\.\d+)\/(\d+)$/: {
			$c = $1
			$nm = netmask_from_masklen($2)
		}
		/^(\d+\.\d+\.\d+\.\d+)\/(\d+\.\d+\.\d+\.\d+)$/: {
			$c = $1
			$nm = $2
		}
	}

	case $ensure {
		present: {
			augeas { "hosts.allow/${daemon}/${c}":
				changes => "clear ${daemon}/clients/${c}",
				onlyif  => "match ${daemon}/clients/${c} size == 0";
			}

			if $nm {
				augeas { "hosts.allow/${daemon}/${c}/netmask":
					changes => "set ${daemon}/clients/${c}/netmask ${nm}",
					onlyif  => "match ${daemon}/clients/${c}/netmask[.='${nm}'] size == 0",
					require => Augeas["hosts.allow/${daemon}/${c}"];
				}
			} else {
				augeas { "hosts.allow/${daemon}/${c}/netmask":
					changes => "rm ${daemon}/clients/${c}/netmask",
					onlyif  => "match ${daemon}/clients/${c}/netmask size > 0",
					require => Augeas["hosts.allow/${daemon}/${c}"];
				}
			}
		}
		absent: {
			augeas { "hosts.allow/${daemon}/${c}":
				changes => [
					"rm ${daemon}/clients/${c}",
					"rm ${daemon}[count(clients/*)=0]",
				],
				onlyif  => "match ${daemon}/clients/${c} size > 0";
			}
		}
	}
}
