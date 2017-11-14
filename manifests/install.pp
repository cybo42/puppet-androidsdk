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
  }

  file {'android_sdk_home':
    ensure => 'directory',
    path   => $androidsdk_home,
    owner  => $android_user,
  }

  # file {'/usr/local/androidsdk':
  #   ensure => directory,
  #   owner  => $android_user,
  #   # group  => $android::group,
  # } ->

  package {'unzip':
    ensure => 'present'
  } ->

  staging::deploy { 'sdk-tools-linux-3859397.zip':
    source  => $androidsdk_source,
    target  => $androidsdk_home,
    creates => "${androidsdk_home}/tools",
    user    => $android_user,
    group   => $android_group,
  }

  file { '/etc/profile.d/androidsdk.sh':
    ensure  => 'file',
    content => template('androidsdk/androidsdk.sh.erb'),
    mode    => '0644',
  }




  # wget::fetch { 'download-android-sdk':
    # source      => $androidsdk_source,
    # destination => '/tmp/sdk.zip',
  # } ->
  # exec { 'unpack-android-sdk':
    # command => 'unzip /tmp/sdk.zip',
    # creates => '/usr/local/androidsdk/tools',
    # cwd     => '/usr/local/androidsdk'
  # }->
  # file { 'android-executable':
    # ensure => present,
    # path   => "${android::paths::toolsdir}/android",
    # owner  => $android::user,
    # group  => $android::group,
    # mode   => '0755',
  # }
}
