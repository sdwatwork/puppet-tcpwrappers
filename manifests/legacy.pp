class tcpwrappers {
	# Fix permissions and ownership on deny file
	file { "/etc/hosts.deny":
		owner => root,
		group => root,
		mode  => 0644;
	}

	# Append default deny if not already there
	appendifnosuchline { hostsdeny:
		line   => "ALL: ALL",
		target => "/etc/hosts.deny";
	}
}

class tcpwrappers::build {
	# Don't actually want default deny enforced during build as it may cause
	# problems for Monitor clients who don't know about it.
}

class tcpwrappers::monitor {
}

class tcpwrappers::secure inherits tcpwrappers {
}

class tcpwrappers::complete inherits tcpwrappers::secure {
}

class tcpwrappers::engineroom inherits tcpwrappers::complete {
}
