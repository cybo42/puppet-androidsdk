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
  $android_sdk_home = '/usr/local/androidsdk',
  $install_packages = [],
) {

  class{'::androidsdk::install':
    androidsdk_home => $android_sdk_home,
  }

  if ! empty($install_packages) {
    $package_file = "${android_sdk_home}/package_install.lst"
    $package_file_script = "${android_sdk_home}/package_install.sh"

    file {'package_file':
      ensure  => 'present',
      path    => $package_file,
      content => template('androidsdk/package_install_file.erb'),
      require => [Class['::androidsdk::install']],
    } ->
    file {'package_file_script':
      ensure  => 'present',
      path    => $package_file_script,
      content => "yes y| ${android_sdk_home}/tools/bin/sdkmanager --verbose --package_file=${package_file}",
      mode    => '0755',
    } ->
    exec { 'install-from-file':
      cwd     => $android_sdk_home,
      command => "bash -c ${package_file_script}",
      path    => ['/usr/bin','/usr/local/bin',"${android_sdk_home}","${android_sdk_home}/tools/bin"]
    }



  }



}
