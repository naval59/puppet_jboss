define jboss7::instances (
  String[1] $description = $title,
  $jboss_home            = $jboss7::jboss_home,
  $jboss_xms             = $jboss7::jboss_xms,
  $jboss_xmx             = $jboss7::jboss_xmx,
  $conf_xml              = $jboss7::conf_xml,
  $app_home              = $jboss7::app_home,
  $instance_name         = $jboss7::instance_name,
  $node_name             = $jboss7::node_name,
  $app_name              = $jboss7::app_name,
  $jmx_port              = $jboss7::jmx_port,
  $rmi_server            = $jboss7::rmi_server,
  $appd_appname          = $jboss7::appd_appname,
  $appd_tiername         = $jboss7::appd_tiername,
  $appd_nodename         = $jboss7::appd_nodename,
  $lifecycle_phase       = $jboss7::lifecycle_phase,
  $lifecycle_phase_env   = $jboss7::lifecycle_phase_env,
  $client                = $jboss7::client,
  $war                   = $jboss7::war,
  $lc                    = $jboss7::lc,
  $sweeper               = $jboss7::sweeper,
  $workflow              = $jboss7::workflow,
  $jboss_homes           = $jboss7::jboss_homes,
  $keystore_url          = $jboss7::keystore_url,
  $keystore_pswd         = $jboss7::keystore_pswd,
  $http_port             = $jboss7::http_port,
  $ajp_port              = $jboss7::ajp_port,
  $https_port            = $jboss7::https_port,
  $management_http_port  = $jboss7::management_http_port,
  $management_https_port = $jboss7::management_https_port,
  $jndi                  = $jboss7::jndi,
  $offset                = $jboss7::offset,
  $pool_name             = $jboss7::pool_name,
  $connection_url        = $jboss7::connection_url,
  $ds_username           = $jboss7::ds_username,
  $ds_password           = $jboss7::ds_password,
  $owners                = $jboss7::owners,
  $stack                 = $jboss7::stack,
  $cluster_members       = $jboss7::cluster_members,
  $num_initial           = $jboss7::num_initial,
  $host_r53              = $jboss7::host_r53,
){
  include jboss7
  $confi                 = $conf_xml ? {
    'cluster'            => 'standalone-full-ha.xml',
    default              => 'standalone.xml',
  }
  file { "${jboss7::jboss_home}/${name}/bin/standalone.conf":
    ensure  => 'file',
    owner   => $jboss7::jboss_user,
    group   => $jboss7::jboss_group,
    mode    => '0750',
    content => epp('jboss7/standalone.conf.epp'),
  }
  file { "${jboss7::jboss_home}/${name}/standalone/configuration/${confi}":
    ensure  => 'file',
    owner   => $jboss7::jboss_user,
    group   => $jboss7::jboss_group,
    mode    => '0750',
    content => epp("jboss7/${confi}.epp"),
  }
  file { "${jboss7::jboss_home}/${name}/standalone/deployments/${war}.war":
    ensure => 'link',
    target => "/opt/pkgs/jboss/${war}.war",
    }
}
