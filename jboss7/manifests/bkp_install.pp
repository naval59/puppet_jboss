class jboss7::install (
)
{
$jboss_group = lookup('jboss_group')
$jboss_user  = lookup('jboss_user')
user { $jboss_user:
  ensure     => present,
  managehome => true,
  home       => "/home/${jboss_user}",
  require    => Group[$jboss_group],
}
group { $jboss_group:
  ensure => present
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

 $def_attri = {
    'ensure' => 'directory',
    'owner'  => 'root',
    'group'  => 'root',
#    'require' => Exec["Ensure jboss home directory created ${jboss_version}"],
}
$jboss7::jboss_bases.each |String $jboss_base| {
 file { "${jboss_home}/${jboss_base}":
     *        => $def_attri
#  ensure  => 'directory',
#  owner   => 'root',
#  group   => 'root',
#  require => Exec["Ensure jboss home directory created ${jboss_version}"],
}
}

  archive { 'Ensure jboss installation':
      path            => "${archive_directory}/${archive_name}",
      extract         => true,
      extract_path    => "${jboss_home}/${jboss_bases}",
      extract_command => 'tar xf %s --strip-components=1',
      creates         => "${jboss_home}/${jboss7::jboss_bases}/LICENSE.txt",
#     require         => File["/opt/jboss/eap7/servers/${jboss_base}"],
 }
Exec["Ensure jboss home directory created ${jboss_version}"] -> File["${jboss_home}/${jboss_base}"] -> Archive['Ensure jboss installation']

}

