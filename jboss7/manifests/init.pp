class  jboss7 (
 Hash $jboss_bases     = { },
  $jboss_home      = '/opt/jboss/eap7/servers',
  $java_version    = '1.8.0_221',
  $java_base       =  "jdk${java_version}",
  $java_home       = '/opt/jboss/eap7/java',
  $jboss_xms       = "2222m",
  $jboss_xmx       = "1111m",
  $jboss_user      = lookup('jboss_user'),
  $jboss_group     = lookup('jboss_group'),
  $http_port       = '8080',
  $ajp_port        = '8009',
  $https_port      = '8443',
  $management_http_port = '9990',
  $management_https_port = '9444',
  $offset          = '0',
  $conf_xml        = default,
  $app_home        = 'test',
  $instance_name   = 'SAALApp2',
  $node_name       = '1_SAALApp2',
  $app_name        = 'Sample-app',
  $jmx_port        = '12345',
  $rmi_server      = 'lvappasp000001p.pri',
  $appd_appname    = '360aspPROD',
  $appd_tiername   = 'saal_tier',
  $appd_nodename   = 'lvappasp000001p__asp-saalapp2',
  $lifecycle_phase = 'pu',
  $lifecycle_phase_env = '1',
  $client              = 'nucleaus',
  $war                 = 'nucleusBase',
  $lc                  = 'pu',
  $sweeper             = 'off',
  $workflow            = 'off',
  $keystore_url        = '/apps/jboss/eap7/vault/vault.keystore',
  $keystore_pswd       = 'MASK-20jhdjhsjd',
  $jndi                = 'Base_nucleuspu',
  $pool_name           = 'Base_nucleuspu',
  $connection_url      = 'jdbc:oracle:thin@pn1-vip.guard:45000:pooon1',
  $ds_username         = 'p000NA',
  $ds_password         = '${vault::pooona::password::1}',
  $owners              = undef,
  $stack               = 'tcp',
  $cluster_members     = 'lvapp001p[7600],lpapp2p[7600],lpapp3p[7600]',
  $num_initial         = undef,
  $host_r53            = 'lpappasp000001p',

#  $jboss_base      = "$jboss_bases['jboss_base']['subkey']",
) {
create_resources("jboss7::instances", $jboss_bases)

contain class { 'jboss7::install': 
  jboss_bases  => $jboss_bases,
  jboss_user   => $jboss_user,
  jboss_group  => $jboss_group,
#  jboss_xms    => $jboss_xms,
#  jboss_xmx    => $jboss_xmx,
#  jboss_base   => $jboss_base,
}
contain class { 'jboss7::java': 
  java_base    => $java_base,
  java_home   => $java_home,
  java_version => $java_version,
  jboss_user   => $jboss_user,
}
#contain class {'jboss7::filemanager': 
#  jboss_bases  => $jboss_bases,
#  jboss_home   => $jboss_home,
#  java_version => $java_version,
#  java_base    => $java_base,
#  java_home    => $java_home,
#}
#contain class { 'jboss7::service':
 #}
#contain class { 'jboss7::config':
#  jboss_bases  => $jboss_bases,
#  jboss_home   => $jboss_home,
#  jboss_xms    => $jboss_xms,
#  jboss_xmx    => $jboss_xmx,
#  jboss_user   => $jboss_user,
#  jboss_group  => $jboss_group,
#}
}

