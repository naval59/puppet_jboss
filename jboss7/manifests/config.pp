class jboss7::config 
(
$jboss_bases,
$jboss_home,
$jboss_xms,
$jboss_xmx,
$jboss_user,
$jboss_group,
#$remote_debug,
#$remote_debug_port,
#$java_opts,

)
{
require jboss7::install
require jboss7::java
$jboss_bases.each |$key, $jboss_base| {
  $jboss_base.each |$subkey, $subvalue| {
file { "${jboss_home}/${subkey}/bin/standalone.conf":
  ensure => 'file',
  owner  => $jboss_user,
  group  => $jboss_group,
  mode   => '0750',
  content => epp("jboss7/standalone.conf.epp",{
    'jboss_xms'          => $subvalue['jboss_xms'],
    'jboss_xmx'          => $subvalue['jboss_xmx'],
#    'remote_debug'       => $remote_debug,
#    'remote_debug_port'  => $remote_debug_port,
}),
}
}
}
}
