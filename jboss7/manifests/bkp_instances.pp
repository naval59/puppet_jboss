define jboss7::instances (
  String[1] $description = $title,
){
  include jboss7
  $jboss7::jboss_bases.each |$_base_name, $jvms| {
    $jvms.each |String[1] $jvm_name, Hash $jvm_properties| {

      notify { "jvm_name: ${jvm_name}":
        message => "properties: ${jvm_properties}",
      }

      file { "${jboss7::jboss_home}/${jvm_name}/bin/standalone.conf":
        ensure        => 'file',
        owner         => $jboss7::jboss_user,
        group         => $jboss7::jboss_group,
        mode          => '0750',
        content       => epp('jboss7/standalone.conf.epp',{
          jboss_xms   => $jvm_properties.get('jboss_xms', $jboss7::jboss_xms),
          jboss_xmx   => $jvm_properties.get('jboss_xmx', $jboss7::jboss_xmx),
          app_home    => $jvm_properties.get('app_home',$jboss7::app_home),
          instance_name => $jvm_properties.get('instance_name',$jboss7::instance_name),
          node_name     => $jvm_properties.get('node_name',$jboss7::node_name),
          app_name      => $jvm_properties.get('app_name',$jboss7::app_name),
          jmx_port      => $jvm_properties.get('jmx_port',$jboss7::jmx_port),
          rmi_server    => $jvm_properties.get('rmi_server',$jboss7::rmi_server),
          appd_appname  => $jvm_properties.get('appd_appname',$jboss7::appd_appname),
          appd_tiername => $jvm_properties.get('appd_tiername',$jboss7::appd_tiername),
          appd_nodename => $jvm_properties.get('appd_nodename',$jboss7::appd_nodename),
          lifecycle_phase => $jvm_properties.get('lifecycle_phase',$jboss7::lifecycle_phase),
          lifecycle_phase_env => $jvm_properties.get('lifecycle_phase_env',$jboss7::lifecycle_phase_env),
          client        => $jvm_properties.get('client',$jboss7::client),
          war           => $jvm_properties.get('war',$jboss7::war),
          lc            => $jvm_properties.get('lc',$jboss7::lc),
          sweeper       => $jvm_properties.get('sweeper',$jboss7::sweeper),
          workflow      => $jvm_properties.get('workflow',$jboss7::workflow),
          jboss_homes   => "${jboss7::jboss_home}/${jvm_name}",
          jvm_name      => "${jvm_name}"
    }),
      }
      $confi = $jvm_properties.get('conf_xml',$jboss7::conf_xml) ? {
          'cluster'  => 'standalone-full-ha.xml',
          default    => 'standalone.xml',
      }
      file { "${jboss7::jboss_home}/${jvm_name}/standalone/configuration/${confi}":
        ensure                   => 'file',
        owner                    => $jboss7::jboss_user,
        group                    => $jboss7::jboss_group,
        mode                     => '0750',
        content                  => epp("jboss7/${confi}.epp",{
            jvm_name             => "${jvm_name}",
            keystore_url         => $jvm_properties.get('keystore_url',$jboss7::keystore_url),
            keystore_pswd        => $jvm_properties.get('keystore_pswd',$jboss7::keystore_pswd),
            http_port            => $jvm_properties.get('http_port',$jboss7::http_port),
            ajp_port             => $jvm_properties.get('ajp_port',$jboss7::ajp_port),
            https_port           => $jvm_properties.get('https_port',$jboss7::https_port),
            management_http_port => $jvm_properties.get('management_http_port',$jboss7::management_http_port),
            management_https_port => $jvm_properties.get('management_https_port',$jboss7::management_https_port),
            app_home             => $jvm_properties.get('app_home',$jboss7::app_home),
            jndi                 => $jvm_properties.get('jndi',$jboss7::jndi),
            offset               => $jvm_properties.get('offset',$jboss7::offset),
            pool_name            => $jvm_properties.get('pool_name',$jboss7::pool_name),
            connection_url       => $jvm_properties.get('connection_url',$jboss7::connection_url),
            ds_username          => $jvm_properties.get('ds_username',$jboss7::ds_username),
            ds_password          => $jvm_properties.get('ds_password',$jboss7::ds_password),
            owners               => $jvm_properties.get('owners',$jboss7::owners),
            stack                => $jvm_properties.get('stack',$jboss7::stack),
            cluster_members      => $jvm_properties.get('cluster_members',$jboss7::cluster_members),
            num_initial          => $jvm_properties.get('num_initial',$jboss7::num_initial),
            host_r53             => $jvm_properties.get('host_r53',$jboss7::host_r53),
        }),
      }
      $warfile                   = $jvm_properties.get('war',$jboss7::war)
      file { "${jboss7::jboss_home}/${jvm_name}/standalone/deployments/${warfile}.war":
        ensure                   => link,
        target                   => "/opt/pkgs/jboss/${warfile}.war",
        }
    }
}
}
