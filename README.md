#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with ld_relay](#setup)
    * [What ld_relay affects](#what-ld_relay-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description
The [LaunchDarkly Relay Proxy](https://github.com/launchdarkly/ld-relay) establishes a connection to the LaunchDarkly streaming API, then proxies that stream connection to multiple clients.

This module configures the [ld-relay](https://github.com/launchdarkly/ld-relay) daemon

## Setup

### What ld_relay affects

* Configuration files
  * /etc/ld-relay.conf
* Listened to ports
  * 8030 (default)

### Setup Requirements

The module expects the ld-relay daemon to be packacked/available via the package manager.

## Usage

Reference the ld-relay [documentation](https://github.com/launchdarkly/ld-relay#configuration-file-format-) for more information about the parameters

### Configuring a single environment
To have puppet install and configure the ld-relay daemon for a single environment:
``` puppet
include ::ld_relay

ld_relay::environment { 'dev':
  api_key => 'sdk-launchdarkly-dev-apiKey',
}
```

### Configuring multiple environments
To have puppet install and configure the ld-relay daemon for multiple environments:
``` puppet
include ::ld_relay

ld_relay::environment { 'dev':
  api_key => 'sdk-launchdarkly-dev-apiKey',
}

ld_relay::environment { 'production':
  api_key => 'sdk-launchdarkly-production-apiKey',
}
```

### Using Redis
You can configure the ld-relay daemon to persist feature flag settings in Redis. This provides durability in case of (e.g.) a temporary network partition that prevents ld-relay from communicating with LaunchDarkly's servers:

``` puppet
class { '::ld_relay':
  enable_redis => true,
  redis_host   => 'redis-host.example.com',
}

ld_relay::environment { 'dev':
  api_key => 'sdk-launchdarkly-dev-apiKey',
}
```

### Using Redis with multiple environments
When using multiple environments, set a Redis key prefix for each environment:

``` puppet
class { '::ld_relay':
  enable_redis => true,
  redis_host   => 'redis-host.example.com',
}

ld_relay::environment { 'dev':
  api_key => 'sdk-launchdarkly-dev-apiKey',
  prefix  => 'ld:dev',
}

ld_relay::environment { 'production':
  api_key => 'sdk-launchdarkly-production-apiKey',
  prefix  => 'ld:production',
}
```

## Reference

#### Class: `ld_relay`

##### `base_uri`
* Sets the base URI of the LaunchDarkly application
* Default: `https://app.launchdarkly.com`

##### `config_file`
* Sets the location of the ld-relay daemon configuration file
* Default: `/etc/ld-relay.conf`

##### `exit_on_error`
* Should the ld-relay daemon exit on errors
* Default: `false`

##### `heartbeat_interval_secs`
* The ld-relay daemon can be configured to send periodic heartbeats to connected clients. This can be useful if you are load balancing ld-relay instances behind a proxy that times out HTTP connections (e.g. Elastic Load Balancers)
* Default: `15`

##### `manage_config`
* Should the configuration file be managed by puppet
* Default: `true`

##### `package_ensure`
* Sets the ensure value of the ld-relay package resource
* Default: `installed`

##### `package_name`
* Sets the ld-relay package name
* Default: `$::ld_relay::params::package_name`

##### `port`
* Sets the listening port for the ld-relay daemon
* Default: `8030`

##### `events_enable`
* The ld-relay daemon can be configured to buffer and forward events to the LaunchDarkly bulk events service. The primary use case for this is PHP environments, where the performance of a local proxy makes it possible to synchronously flush analytics events.
* Default: `true`

##### `events_uri`
* URI of LaunchDarkly events endpoint
* Default: `https://events.launchdarkly.com`

##### `events_send`
* Should events be forwarded to the LaunchDarkly events endpoint
* Default: `true`

##### `events_flush_interval`
* How often should events be flushed from the buffer (in seconds)
* Default: `5`

##### `events_sampling_interval`
* Unclear if this actually does anything
* Default: `0`

##### `events_capacity`
* Maximum number of events in the buffer
* Default: `10000`

##### `redis_enable`
* The ld-relay daemon can be configured to persist feature flag settings in Redis. This provides durability in case of (e.g.) a temporary network partition that prevents ld-relay from communicating with LaunchDarkly's servers.
* Default: `false`

##### `redis_host`
* Sets the Redis hostname
* Default: `localhost`

##### `redis_port`
* Sets the Redis port
* Default: `6379`

##### `redis_local_ttl`
* An in-memory cache for the ld-relay daemon to use so that connections do not always hit redis.
* Sets the time-to-live in milliseconds
* Default: `30000`

##### `service_enable`
* Whether the ld-relay service should be started at boot
* Default: `true`

##### `service_ensure`
* Whether the ld-relay service should be running
* Default: `running`

##### `service_manage`
* Whether the ld-relay service is managed
* Default: `true`

##### `service_name`
* Sets the ld-relay service name
* Default: `$::ld_relay::params::service_name`

##### `stream_uri`
* Sets the URI of the Launch Darkly streaming service
* Default: `https://stream.launchdarkly.com`

### Class `ld_relay::environment`
Creates ld_relay defined types.  There can be multiple defined environments.

##### `environment`
* Sets the name of the environment
* Default: `$name`

#### `api_key`
* Sets the Launch Darkly API key for the environment
* This parameter is required

##### `prefix`
* Sets the Redis key prefix for the environment
* When using multiple environments, set this.  If not, all of the environments will set the same key in Redis.
* Default: `undef`

## Limitations

The module is only tested against RedHat/CentOS 7
