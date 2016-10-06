tcpwrappers
=============

[![Build Status](https://travis-ci.org/MiamiOH/puppet-tcpwrappers.svg)](https://travis-ci.org/MiamiOH/puppet-tcpwrappers)
[![Puppet Forge](https://img.shields.io/puppetforge/v/MiamiOH/tcpwrappers.svg)](https://forge.puppet.com/MiamiOH/tcpwrappers)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/MiamiOH/tcpwrappers.svg)](https://forge.puppet.com/MiamiOH/tcpwrappers)
[![Puppet Forge Score](https://img.shields.io/puppetforge/f/MiamiOH/tcpwrappers.svg)](https://forge.puppet.com/MiamiOH/tcpwrappers/scores)

Formerly:
[netmanagers/puppet-tcpwrappers](https://github.com/netmanagers/puppet-tcpwrappers)

## Getting started

This is a Puppet module for tcpwrappers

It provides only package installation and file configuration (hosts.allow / hosts.deny).

Based on:

* TCPWrappers puppet module created by Anchor Systems (https://github.com/wido/puppet-module-tcpwrappers), from where the main logic was taken.

* Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

## USAGE - Basic management

TCP wrappers are installed by default in almost every Linux system around and you'll rarely use
this capabilities, but they are provided by every Example42 module, so they are available here too.
I just removed the "harmful" ones, like the possibility to remove the package.

* Install tcpwrappers with default settings

        class { 'tcpwrappers': }

* Managing entries in */etc/hosts.allow* and */etc/hosts.deny*.

  Parameters *daemon* defaults to **ALL** and *client* defaults to **$title** if not specified.

        # Simple client specification
        tcpwrappers::allow { '192.0.2.0/24': }

  and

        tcpwrappers::allow { foo:
          daemon => "ALL",
          client => "192.0.2.0/24";
        }

  are equivalent, and add an entry

        ALL: 192.0.2.0/24

  into */etc/hosts.allow*

        # With an exception specification
        tcpwrappers::allow { foo:
          daemon => "daemon",
          client => "ALL",
          except => "/etc/hosts.deny.inc";
        }

  Adds an entry

        daemon: ALL EXCEPT "/etc/hosts.deny.inc"


  tcpwrappers::deny accepts the same parameters

  The following parameters are available:

  * *ensure*: Whether the entry should be "present" or "absent".
  * *daemon*: The identifier supplied to libwrap by the daemon, often just the
              process name.
  * *client*: The client specification to be added.
  * *except* (optional): Another client specification, acting as a filter for the first
             client specifiction.

  The $client and $except parameters must have one of the following forms:

        FQDN:          example.com
        Domain suffix: .example.com
        IP address:    192.0.2.1
        IP prefix:     192. 192.0. 192.0.2.
        IP range:      192.0.2.0/24 192.0.2.0/255.255.255.0
        Filename:      /path/to/file.acl
        Keyword:       ALL LOCAL PARANOID

   The client specification will be normalized before being matched against
   or added to the existing entries in hosts.allow/hosts.deny.


* Install a specific version of tcpwrappers package

        class { 'tcpwrappers':
          version => '1.0.1',
        }

* Enable auditing without without making changes on existing tcpwrappers configuration *files*

        class { 'tcpwrappers':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'tcpwrappers':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file

        class { 'tcpwrappers':
          allow_source => [ "puppet:///modules/netmanagers/tcpwrappers/hosts_allow-${hostname}",
                            "puppet:///modules/netmanagers/tcpwrappers/hosts_allow.conf" ],
          deny_source  => [ "puppet:///modules/netmanagers/tcpwrappers/hosts_deny-${hostname}",
                            "puppet:///modules/netmanagers/tcpwrappers/hosts_allow.conf" ],
        }


* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'tcpwrappers':
          allow_template => 'netmanagers/tcpwrappers/hosts_allow.erb',
        }

  and provide custom values using the "$options" parameter.

* Automatically include a custom subclass

        class { 'tcpwrappers':
          my_class => 'netmanagers::my_tcpwrappers',
        }
