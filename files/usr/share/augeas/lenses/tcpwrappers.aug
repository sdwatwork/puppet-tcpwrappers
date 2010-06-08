(* 
Module: Tcpwrappers
    Parses /etc/hosts.allow, /etc/hosts.deny

Author: Tim Sharpe <tim.sharpe@anchor.net.au>

*)

module Tcpwrappers =

autoload xfm

(* 
 * Group: Useful primitives
 *
 *)

let eol             = Util.eol
let comment         = Util.comment
let empty           = Util.empty
let opt_ws          = Util.del_opt_ws " "
let ws              = Util.del_ws " "
let colon           = Util.del_str ":"
let slash           = Util.del_str "/"
let at              = Util.del_str "@"
let comma_and_ws    = del /,[ \t]+/ ", "
let comma_andor_ws  = del /[ ,\t]+/ ", "
let daemon          = /[A-Za-z0-9_\.-]+/
let masklen_val     = store /[0-9]{1,2}/
let ip_val          = store /([0-9]{1,3}\.){3}[0-9]{1,3}/
let client_val      = /[^ A-Z\t\n,\/]+/
let host_val        = store /[^ \n\t:\/]+/
let ws_val          = /[ \t\n]+/
let store_to_ws     = store /[^ ,\t\n]+/

let masklen         = [ label "masklen" . masklen_val ]
let netmask         = [ label "netmask" . ip_val ]
let bind_addr       = [ label "bind_addr" . host_val ]
let wildcard_val    = /(ALL|LOCAL|UNKNOWN|KNOWN|PARANOID)/
let operator        = /EXCEPT/

let except          = [ key operator . ws . store_to_ws ]
let wildcard        = [ key wildcard_val . (ws . except)* ]
let client          = [ key client_val . (slash . (netmask|masklen))? ]

let clients         = [ label "clients" . (client|wildcard) . (comma_andor_ws . (client|wildcard))* ]
let entry           = [ key daemon . (at . bind_addr)? . opt_ws . colon . opt_ws . clients . eol ]

let lns             = (comment|empty|entry) *

let filter          = incl "/etc/hosts.allow"
                        . incl "/etc/hosts.deny"
                        . Util.stdexcl

let xfm             = transform lns filter
