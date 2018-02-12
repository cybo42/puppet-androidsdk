#
class androidsdk::install(
  $androidsdk_home,
){

  $android_user  = 'android'
  $android_group = 'android'

  $androidsdk_source='https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip'

  user { $android_user:
    ensure     => 'present',
    comment    => 'Android SDK user account',
    home       => $androidsdk_home,
    managehome => false,
    system     => true,
  } ->

  file {'android_sdk_home':
    ensure => 'directory',
    path   => $androidsdk_home,
    owner  => $android_user,
  } ->

  package {'unzip':
    ensure => 'present'
  } ->

  staging::deploy { 'sdk-tools-linux-3859397.zip':
    source  => $androidsdk_source,
    target  => $androidsdk_home,
    creates => "${androidsdk_home}/tools",
    user    => $android_user,
    group   => $android_group,
  } ->
  exec { 'android-cli-executable':
    command => "find ${androidsdk_home}/tools/bin/ -exec chmod 755 {} \\;",
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    cwd     => $androidsdk_home,
  }

  file { '/etc/profile.d/androidsdk.sh':
    ensure  => 'file',
    content => template('androidsdk/androidsdk.sh.erb'),
    mode    => '0644',
  }

}
