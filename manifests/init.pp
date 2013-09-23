# = Class: tcpwrappers
#
# This is the main tcpwrappers class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, tcpwrappers class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $tcpwrappers_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, tcpwrappers main config file will have the param:
#   source => $source
#   Can be defined also by the (top scope) variable $tcpwrappers_source
#
# [*source_dir*]
#   If defined, the whole tcpwrappers configuration directory content is
#   retrieved recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $tcpwrappers_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $tcpwrappers_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, tcpwrappers main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $tcpwrappers_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $tcpwrappers_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $tcpwrappers_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $tcpwrappers_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in tcpwrappers::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of tcpwrappers package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include tcpwrappers"
# - Call tcpwrappers as a parametrized class
#
# See README for details.
#
#
class tcpwrappers (
  $my_class            = params_lookup( 'my_class' ),
  $allow_file          = params_lookup( 'allow_file' ),
  $allow_source        = params_lookup( 'allow_source' ),
  $deny_source         = params_lookup( 'deny_source' ),
  $deny_file           = params_lookup( 'deny_file' ),
  $allow_template      = params_lookup( 'allow_template' ),
  $deny_template       = params_lookup( 'deny_template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' )
  ) inherits tcpwrappers::params {

  $config_file_mode=$tcpwrappers::params::config_file_mode
  $config_file_owner=$tcpwrappers::params::config_file_owner
  $config_file_group=$tcpwrappers::params::config_file_group

  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $tcpwrappers::version ? {
    ''      => 'present',
    default => $tcpwrappers::version,
  }

  $manage_file = 'present'

  $manage_audit = $tcpwrappers::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $tcpwrappers::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_allow_file_source = $tcpwrappers::allow_source ? {
    ''        => undef,
    default   => $tcpwrappers::allow_source,
  }

  $manage_allow_file_content = $tcpwrappers::allow_template ? {
    ''        => undef,
    default   => template($tcpwrappers::allow_template),
  }

  $manage_deny_file_source = $tcpwrappers::deny_source ? {
    ''        => undef,
    default   => $tcpwrappers::deny_source,
  }

  $manage_deny_file_content = $tcpwrappers::deny_template ? {
    ''        => undef,
    default   => template($tcpwrappers::deny_template),
  }

  ### Managed resources
  package { $tcpwrappers::package:
    ensure  => $tcpwrappers::manage_package,
    noop    => $tcpwrappers::bool_noops,
  }

  file { 'allow.file':
    ensure  => $tcpwrappers::manage_file,
    path    => $tcpwrappers::allow_file,
    mode    => $tcpwrappers::config_file_mode,
    owner   => $tcpwrappers::config_file_owner,
    group   => $tcpwrappers::config_file_group,
    require => Package[$tcpwrappers::package],
    source  => $tcpwrappers::manage_allow_file_source,
    content => $tcpwrappers::manage_allow_file_content,
    replace => $tcpwrappers::manage_file_replace,
    audit   => $tcpwrappers::manage_audit,
    noop    => $tcpwrappers::bool_noops,
  }

  file { 'deny.file':
    ensure  => $tcpwrappers::manage_file,
    path    => $tcpwrappers::deny_file,
    mode    => $tcpwrappers::config_file_mode,
    owner   => $tcpwrappers::config_file_owner,
    group   => $tcpwrappers::config_file_group,
    require => Package[$tcpwrappers::package],
    source  => $tcpwrappers::manage_deny_file_source,
    content => $tcpwrappers::manage_deny_file_content,
    replace => $tcpwrappers::manage_file_replace,
    audit   => $tcpwrappers::manage_audit,
    noop    => $tcpwrappers::bool_noops,
  }

  ### Include custom class if $my_class is set
  if $tcpwrappers::my_class {
    include $tcpwrappers::my_class
  }

}
