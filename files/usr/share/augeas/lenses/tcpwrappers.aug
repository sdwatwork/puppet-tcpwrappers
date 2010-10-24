module Tcpwrappers =
	autoload xfm

	let ws        = /[ \t]|\\\\\n/+
	let any       = /[^ \n\t,:#]+/
	let dot       = /\./
	let at        = /@/
	let slash     = /\//
	let component = /[a-z0-9_-]+/
	let fqdn      = component . ( dot . component )*
	let wild      = /[a-z0-9_*?-]+/
	let fqdnwild  = wild . ( dot . wild )*
	let digits    = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/
	let ipv4      = digits . dot . digits . dot . digits . dot . digits
	let prefix    = digits . dot . ( digits . dot . ( digits . dot )? )?
	let ipv6      = /\[/ . Rx.ipv6 . /\]/
	let ipv6len   = /0|1([01][0-9]?|2[0-7]?|[3-9])?|[2-9][0-9]?/
	let username  = /[a-z_.-]+/ | "UNKNOWN" | "KNOWN"
	let netgroup  = at . any+
	let filename  = slash . any+
	let process   = /[a-z0-9_][a-z0-9_.-]*[a-z0-9_]|[a-z0-9_]/
	              | "ALL"

	let host      = fqdn | ipv4 | ipv6
	let range     = dot? . fqdn
	              | fqdnwild
	              | ipv4 . ( slash . ipv4 )?
	              | ipv6 . ( slash . ipv6len )?
	              | prefix
	              | "ALL" | "LOCAL" | "PARANOID"

	let indent  = del ws? ""
	let eol     = del /[ \t]*(#.*)?\n/ "\n"
	let comment = Util.comment
	let empty   = Util.empty
	let list    = Build.opt_list
	let colon   = del ( ws? . ":" . ws? ) ": "
	let comma   = del ( ws? . "," . ws? | ws ) ", "
	let except  = del ( ws . "EXCEPT" . ws ) " EXCEPT "

	let daemon = [ label "daemon"
	           . store ( process . ( at . host )? ) ]
	let client = [ label "client"
	           . store ( netgroup
	                   | ( username . at )? . range
	                   | filename
	                   ) ]

	let entry = [ label "entry"
	            . indent
	            . [ label "daemons"
	              . list daemon comma
	              . [ label "except" . except . list daemon comma ]? ]
	            . colon
	            . [ label "clients"
	              . list client comma
	              . [ label "except" . except . list client comma ]? ]
	            . eol ]

	let lns = ( comment | empty | entry )*

	let filter = incl "/etc/hosts.allow"
	           . incl "/etc/hosts.deny"
	           . Util.stdexcl

	let xfm = transform lns filter
