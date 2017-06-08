# Class: ld_relay
# ===========================
#
# The LaunchDarkly Relay Proxy (https://github.com/launchdarkly/ld-relay)
# establishes a connection to the LaunchDarkly streaming API, then proxies that
# stream connection to multiple clients.
#
# This module configures the ld-relay
# (https://github.com/launchdarkly/ld-relay) daemon
#
# Parameters
# ----------
#
#  [*base_uri*]
#    Sets the base URI for the LaunchDarkly app. Defaults to 'https://app.launchdarkly.com'
#
#  [*config_file*]
#    The location of the ld-relay configuration file. Defaults to '/etc/ld-relay.conf'
#
#  [*exit_on_error*]
#    Should the ld-relay daemon exit on errors. Defaults to false
#
#  [*heartbeat_interval_secs*]
#    The ld-relay daemon can be configured to send periodic heartbeats to
#    connected clients. This can be useful if you are load balancing ld-relay
#    instances behind a proxy that times out HTTP connections
#    (e.g. Elastic Load Balancers.) Defaults to 15
#
#  [*manage_config*]
#    Should the configuration file for ld-relay be managed by puppet. Defaults to true
#
#  [*package_ensure*]
#    Sets the ensure value of the ld-relay package resource. Defaults to 'installed'
#
#  [*package_name*]
#    Sets the name of the ld-relay package. Default is configured by $::ld_relay::params::package_name
#
#  [*port*]
#    Sets the listening port for the ld-relay daemon. Defaults to 8030
#
#  [*events_enable*]
#    The ld-relay daemon can be configured to buffer and forward events to the
#    LaunchDarkly bulk events service. The primary use case for this is PHP
#    environments, where the performance of a local proxy makes it possible to
#    synchronously flush analytics events. Defaults to true
#
#  [*events_uri*]
#    URI of LaunchDarkly events endpoint. Defaults to https://events.launchdarkly.com
#
#  [*events_send*]
#    Should events be forwarded to the LaunchDarkly events endpoint. Defaults to true
#
#  [*events_flush_interval*]
#    How often should events be flushed from the buffer (in seconds). Defaults to 5
#
#  [*events_sampling_interval*]
#    Unclear if this actually does anything. Defaults to 0
#
#  [*events_capacity*]
#    Maximum number of events in the buffer. Defaults to 10000
#
#  [*redis_enable*]
#    The ld-relay daemon can be configured to persist feature flag settings in
#    Redis. This provides durability in case of (e.g.) a temporary network
#    partition that prevents ld-relay from communicating with LaunchDarkly's
#    servers. Defaults to false
#
#  [*redis_host*]
#    Sets the Redis hostname. Defaults to 'localhost'
#
#  [*redis_port*]
#    Sets the Redis port. Defaults to 6379
#
#  [*redis_local_ttl*]
#    An in-memory cache for the ld-relay daemon to use so that connections do not always hit redis. Sets
#    the time-to-live in milliseconds. Defaults to 30000
#
#  [*service_enable*]
#    Whether the ld-relay service should be started at boot. Defaults to true
#
#  [*service_ensure*]
#    Whether the ld-relay service should be running. Defaults to 'running'
#
#  [*service_manage*]
#    Whether the ld-relay service is managed by puppet. Defaults to true
#
#  [*service_name*]
#    Sets the ld-relay service name. Default is configured by $::ld_relay::params::service_name
#
#  [*stream_uri*]
#    Sets the URI of the Launch Darkly streaming service. Defaults to 'https://stream.launchdarkly.com'
#
class ld_relay (
  $base_uri                 = 'https://app.launchdarkly.com',
  $config_file              = '/etc/ld-relay.conf',
  $exit_on_error            = false,
  $heartbeat_interval_secs  = 15,
  $manage_config            = true,
  $package_ensure           = 'installed',
  $package_name             = $::ld_relay::params::package_name,
  $port                     = 8030,
  $events_enable            = true,
  $events_uri               = 'https://events.launchdarkly.com',
  $events_send              = true,
  $events_flush_interval    = 5,
  $events_sampling_interval = 0,
  $events_capacity          = 10000,
  $redis_enable             = false,
  $redis_host               = 'localhost',
  $redis_local_ttl          = 30000,
  $redis_port               = 6379,
  $service_enable           = true,
  $service_ensure           = 'running',
  $service_manage           = true,
  $service_name             = $::ld_relay::params::service_name,
  $stream_uri               = 'https://stream.launchdarkly.com',

) inherits ::ld_relay::params {

  validate_bool($exit_on_error)
  validate_bool($manage_config)
  validate_bool($redis_enable)
  validate_bool($events_enable)
  validate_bool($service_enable)
  validate_bool($service_manage)
  validate_integer($heartbeat_interval_secs)
  validate_integer($port)
  validate_integer($events_flush_interval)
  validate_integer($events_sampling_interval)
  validate_integer($events_capacity)
  validate_integer($redis_local_ttl)
  validate_integer($redis_port)

  case $service_ensure {
    true, false, 'running', 'stopped': {
      $_service_ensure = $service_ensure
    }
    default: {
      $_service_ensure = undef
    }
  }

  $_exit_on_error = bool2str($exit_on_error)
  $_events_send = bool2str($events_send)

  class { '::ld_relay::install': }
  ~> class { '::ld_relay::config': }
  ~> class { '::ld_relay::service': }
  -> Class['::ld_relay']
}
