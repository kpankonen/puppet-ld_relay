# == Class ld_relay::config
#
# This class is called from ld_relay for service config.
#
class ld_relay::config {

  assert_private()

  $base_uri                = $::ld_relay::base_uri
  $config_file             = $::ld_relay::config_file
  $exit_on_error           = $::ld_relay::_exit_on_error
  $heartbeat_interval_secs = $::ld_relay::heartbeat_interval_secs
  $manage_config           = $::ld_relay::manage_config
  $port                    = $::ld_relay::port
  $redis_enable            = $::ld_relay::redis_enable
  $redis_host              = $::ld_relay::redis_host
  $redis_local_ttl         = $::ld_relay::redis_local_ttl
  $redis_port              = $::ld_relay::redis_port
  $stream_uri              = $::ld_relay::stream_uri

  if $manage_config {
    concat { 'ld_relay_config':
      path   => $config_file,
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
      notify => Service['ld-relay'],
    }

    concat::fragment { 'ld_relay_config_global':
      target  => 'ld_relay_config',
      content => template('ld_relay/ld_relay_config_global.erb'),
      order   => '00',
    }
  }
}
