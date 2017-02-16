# == Class ld_relay::install
#
# This class is called from ld_relay for install.
#
class ld_relay::install {

  assert_private()

  package { $::ld_relay::package_name:
    ensure => $::ld_relay::package_ensure,
  }
}
