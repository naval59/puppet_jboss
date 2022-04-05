class jboss7::install (
   $jboss_bases,
   $jboss_user,
   $jboss_group,
#   $jboss_base,
){
#$jboss_user = lookup('jboss_user')
#$jboss_group = lookup('jboss_group')

user { $jboss_user:
  ensure     => present,
  managehome => true,
  home       => "/home/${jboss_user}",
  require    => Group[$jboss_group],
}
group { $jboss_group:
  ensure     => present
}
$archive_directory   = '/opt/pkgs/jboss'
$jboss_version       = '7.3'
$jboss_home          = '/opt/jboss/eap7/servers'
$archive_name        = "jboss-eap-${jboss_version}.tar"

exec { "Ensure jboss home directory created ${jboss_version}":
  command => "/bin/mkdir -p ${jboss_home}",
  cwd     => '/opt',
  unless  => "/usr/bin/stat -c '%U' ${jboss_home} | /bin/grep -q ${jboss_user}",
  require => User[$jboss_user],
}

#$jboss_bases = [ 'jboss1', 'jboss3' ]
$jboss7::jboss_bases.each |$subkey, $subvalue| {
#  $jboss_base.each |$subkey, $subvalue| {
file { "${jboss_home}/${subkey}":
  ensure  => 'directory',
#   *       => $jboss_base,
  owner   => 'jboss',
  group   => 'jboss',
  require => Exec["Ensure jboss home directory created ${jboss_version}"],
}
exec { "Ensure jboss installation of ${subkey}":
  path                  => '/usr/bin',
  command               => "tar -xvf ${archive_directory}/${archive_name} -C ${jboss_home}/${subkey} --strip-components=1",
  creates               => "${jboss_home}/${subkey}/LICENSE.txt",
  require               => File["${jboss_home}/${subkey}"],
}
exec  { "Ensure permission for jboss ${subkey}":
  path                  => '/usr/bin',
  command               => "chown jboss:jboss -R ${jboss_home}",
  require               => Exec["Ensure jboss installation of ${subkey}"],
}

}
Jboss7::Instances { $title:
}

}
