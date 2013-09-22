# Puppet module: tcpwrappers

This is a Puppet module for tcpwrappers
It provides only package installation and file configuration.

Based on 

* TCPWrappers puppet module created by Anchor Systems (https://github.com/wido/puppet-module-tcpwrappers)

* Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-tcpwrappers

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

TCP wrappers are installed by default in almost every Linux system around, so you'll rarely use
this capabilities, but they are provided by every Example42 module, so they are available here too.
I just removed the "harmful" ones, like the possibility to remove the package.

* Install tcpwrappers with default settings

        class { 'tcpwrappers': }

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
          source => [ "puppet:///modules/netmanagers/tcpwrappers/tcpwrappers.conf-${hostname}" , "puppet:///modules/netmanagers/tcpwrappers/tcpwrappers.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'tcpwrappers':
          source_dir       => 'puppet:///modules/netmanagers/tcpwrappers/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'tcpwrappers':
          template => 'netmanagers/tcpwrappers/tcpwrappers.conf.erb',
        }

* Automatically include a custom subclass

        class { 'tcpwrappers':
          my_class => 'netmanagers::my_tcpwrappers',
        }



## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-tcpwrappers.png?branch=master)](https://travis-ci.org/netmanagers/puppet-tcpwrappers)
