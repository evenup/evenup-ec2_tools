# == Class: ec2_tools
#
# This class is able to install the AWS ec2 CLI tools on a node.
#
#
# === Parameters
#
# [*s3cmd*]
#   Boolean.  Whether or not the s3cmd package should be installed
#   Default: true
#
# [*python*]
#   Boolean.  Whether or not the python aws cli tools should be installed
#   Default: true
#   Note: this asumes the awscli package is available via your default package manager
#
# [*java*]
#   Boolean.  Whether or not the java tools should be installed
#   Default: false
#
# [*s3_access_key*]
#   String.  Access key to be configured for s3cmd
#
# [*s3_secret_key*]
#   String.  Secret key to be configured for s3cmd
#
# [*ec2_tools_version*]
#   String. Controls the version of ec2-api-tools to be installed
#   Defaults to 1.6.6.1`.
#
# [*iam_tools_version*]
#   String. Controls the version of iam-tools to be installed
#   Defaults to 1.5.0`.
#
#
# === Examples
#
# * Installation:
#     class { 'ec2_tools': }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class ec2_tools(
  $s3cmd              = true,
  $python             = true,
  $java               = false,
  $s3_access_key      = '',
  $s3_secret_key      = '',
  $ec2_tools_version  = '1.6.6.1',
  $iam_tools_version  = '1.5.0',
  $static_url         = 'files',
) {

  if $s3cmd == true {
    package { 's3cmd':
      ensure  => latest,
    }

    file { '/root/.s3cfg':
      ensure  => file,
      mode    => '0400',
      owner   => root,
      group   => root,
      content => template('ec2_tools/s3cfg.erb'),
    }
  } else {
    package { 's3cmd':
      ensure  => absent,
    }
  }

  if $python == true {
    package { 'python-awscli':
      ensure  => latest,
    }
  } else {
    package { 'python-awscli':
      ensure  => absent,
    }
  }

  if $java == true {
    include java

    $ec2_dir_name = "ec2-api-tools-${ec2_tools_version}"
    $iam_dir_name = "iamcli-${iam_tools_version}"
    $ec2_filename = "${ec2_dir_name}.zip"
    $iam_filename = "${iam_dir_name}.zip"
    $tmpdir = '/tmp'

    file {  '/etc/profile.d/ec2_tools.sh':
      ensure => file,
      mode   => '0555',
      owner  => root,
      group  => root,
      source => 'puppet:///modules/ec2_tools/ec2_tools.profile'
    }

    exec { 'ec2_tools-fetch':
      command   => "/usr/bin/curl -o ${tmpdir}/${ec2_filename} ${static_url}/${ec2_filename}",
      onlyif    => "test ! -d /opt/${ec2_dir_name}",
      cwd       => '/tmp',
      path      => '/usr/bin/',
      logoutput => on_failure,
      notify    => Exec['ec2_tools-decompress']
    }

    exec { 'iam_tools-fetch':
      command   => "/usr/bin/curl -o ${tmpdir}/${iam_filename} ${static_url}/${iam_filename}",
      onlyif    => "test ! -d /opt/${iam_dir_name}",
      cwd       => '/tmp',
      path      => '/usr/bin/',
      logoutput => on_failure,
      notify    => Exec['iam_tools-decompress']
    }

    exec { 'ec2_tools-decompress':
      command     => "/usr/bin/unzip ${tmpdir}/${ec2_filename} -d /opt",
      refreshonly => true,
      unless      => "test -l /opt/${ec2_dir_name}",
      cwd         => '/tmp',
      path        => '/usr/bin/',
      logoutput   => on_failure,
      before      => File['/opt/ec2-api-tools'];
    }

    exec { 'iam_tools-decompress':
      command     => "/usr/bin/unzip ${tmpdir}/${iam_filename} -d /opt",
      refreshonly => true,
      unless      => "test -l /opt/${iam_dir_name}",
      cwd         => '/tmp',
      path        => '/usr/bin/',
      logoutput   => on_failure,
      before      => File['/opt/ec2-api-tools'];
    }

    file { '/opt/ec2-api-tools':
      ensure => link,
      target => "/opt/${ec2_dir_name}"
    }

    file { '/opt/iam-api-tools':
      ensure => link,
      target => "/opt/${iam_dir_name}"
    }
  } else {
    # Remove java tools
    $ec2_dir_name = "ec2-api-tools-${ec2_tools_version}"
    $iam_dir_name = "iamcli-${iam_tools_version}"

    file {  '/etc/profile.d/ec2_tools.sh':
      ensure => absent,
    }

    file { '/opt/ec2-api-tools':
      ensure => absent,
      target => "/opt/${ec2_dir_name}",
    }

    file { '/opt/iam-api-tools':
      ensure => absent,
      target => "/opt/${iam_dir_name}",
    }

    file { "/opt/${ec2_dir_name}":
      ensure  => absent,
      force   => true,
      recurse => true,
    }

    file { "/opt/${iam_dir_name}":
      ensure  => absent,
      force   => true,
      recurse => true,
    }


  }
}
