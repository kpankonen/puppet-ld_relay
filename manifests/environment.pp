# == Class ld_relay::environment
#
# Configures a launchdarkly environment
#

define ld_relay::environment (
  $environment = $name,
  $api_key     = undef,
  $prefix      = undef,
) {

  if ! defined(Class['ld_relay']) {
    fail('The ld_relay base class must be included before defining environments')
  }

  if ! $api_key {
    fail('Ld_relay::Environment: parameter api_key is required')
  }

  concat::fragment { "ld_relay_config_${environment}":
    target  => 'ld_relay_config',
    content => template('ld_relay/ld_relay_config_environment.erb'),
    order   => 10,
  }
}
