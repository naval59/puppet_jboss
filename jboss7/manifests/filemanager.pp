class jboss7::filemanager (
$jboss_bases, 
#$jboss_base,
$jboss_home,
$java_version,
$java_home,
$java_base,
){
require jboss7::install
require jboss7::java
  $conf_files            = [
    "${jboss_home}/${jboss_bases}/bin/standalone.conf",

  ]
notify {"hello guys ${jboss_bases}":}
$javaopts_data_lookup = {
  name          => 'javaopts_data',
  default_value => [],
  merge         => 'first',
}
$javaopts_data  = lookup($javaopts_data_lookup)
$custom_java_opts = join([ "#Glic Specific:\n" , join($javaopts_data,"\n"), "\n" ],'')

$jboss_bases.each |$subkey, $subvalue| {
# $base.each |$subkey, $subvalue| {
$target = "${jboss_home}/${subkey}/bin/standalone.conf"
#notify {" $target":}
shellvar { "JAVA_HOME for ${subkey}":
  ensure   => present,
  target   => $target,
  value    => "${java_home}/${java_base}",
  }
shellvar { "JBOSS_HOME for ${subkey}":
  ensure   => present,
  target   => $target,
  value    => "${jboss_home}/${subkey}",
  }
  
}
#}
}
