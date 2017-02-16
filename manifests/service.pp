# == Class ld_relay::service
#
# This class is meant to be called from ld_relay.
# It ensure the service is running.
#
class ld_relay::service (
  $service_enable     = $::ld_relay::service_enable,
  $service_ensure     = $::ld_relay::service_ensure,
  $service_manage     = $::ld_relay::service_manage,
  $service_hasrestart = true,
  $service_hasstatus  = true,
) {

  assert_private()

  if ! defined(Class['ld_relay::params']) {
    fail('The ld_relay::params class must be included before using service')
  }

  case $service_ensure {
    true, false, 'running', 'stopped': {
      $_service_ensure = $service_ensure
    }
    default: {
      $_service_ensure = undef
    }
  }

  if $service_manage {
    service { $::ld_relay::service_name:
      ensure     => $_service_ensure,
      enable     => $service_enable,
      hasstatus  => $service_hasstatus,
      hasrestart => $service_hasrestart,
    }
  }
}
