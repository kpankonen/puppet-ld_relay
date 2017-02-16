# == Class ld_relay::params
#
# This class is meant to be called from ld_relay.
# It sets variables according to platform.
#
class ld_relay::params {

  assert_private()

  case $::osfamily {
    'RedHat', 'Amazon': {
      $package_name = 'ld-relay'
      $service_name = 'ld-relay'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
