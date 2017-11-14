# == Class: androidsdk
#
# Full description of class androidsdk here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'androidsdk':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class androidsdk(
  $install_packages = []
) {

  class{'::androidsdk::install': }

  if ! empty($install_packages) {

    file {'/usr/local/androidsdk/package_install.lst':
      ensure  => 'present',
      content => template('androidsdk/package_install_file.erb'),
    } ->
    file {'/usr/local/androidsdk/package_install.sh':
      ensure  => 'present',
      content => 'yes y| /usr/local/androidsdk/tools/bin/sdkmanager --verbose --package_file=/usr/local/androidsdk/package_install.lst',
      mode    => '0755',
    } ->
    exec { 'install-from-file':
      cwd     => '/usr/local/androidsdk',
      command => 'bash -c /usr/local/androidsdk/package_install.sh',
      path    => ['/usr/bin','/usr/local/bin','/usr/local/androidsdk','/usr/local/androidsdk/tools/bin/'],
    }



  }



}
