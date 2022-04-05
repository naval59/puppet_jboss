class jboss7::service ( 
#  String[1] $description = $title,
)
{
#   include jboss7
#  require jboss7::install
  $jboss7::jboss_bases.each |$_base_name, $jvms| {
  $jvms.each |String[1] $jvm_name, Hash $jvm_properties| {
    file { "/etc/default/${jvm_name}.conf":
      ensure                    => present,
      mode                      => '0750',
      content                   => epp('jboss7/jboss_conf_service.epp',{
        jvm_name                => "${jvm_name}",
        jboss_homes             => "${jboss7::jboss_home}/${jvm_name}",
        conf_xml                => "$jvm_properties.get('conf_xml',$jboss7::conf_xml)",
        }),
        }
    file { "${jboss7::jboss_home}/${jvm_name}/bin/init.d/${jvm_name}.sh":
      ensure                     => present,
      mode                       => '0750',
      content                    => epp('jboss7/jboss_service.epp',{
        jvm_name                 => "${jvm_name}",
        jboss_homes              => "${jboss7::jboss_home}/${jvm_name}",
        }),
        require                  => File["/etc/default/${jvm_name}.conf"],
#        notify                   => Service["/etc/systemd/system/${jvm_name}.service"],
        }
    file { "/etc/systemd/system/${jvm_name}.service":
      ensure                     => present,
      mode                       => '0750',
      content                    => epp('jboss7/jboss7service.epp',{
        jvm_name                 => "${jvm_name}",
        jboss_homes              => "${jboss7::jboss_home}/${jvm_name}",
        }),
        require                  => File["${jboss7::jboss_home}/${jvm_name}/bin/init.d/${jvm_name}.sh"],
 #       notify                   => Service["/etc/systemd/system/${jvm_name}.service"],
        }

    service { "${jvm_name}.service":
      enable                     => true,
      ensure                     => running,
#      enable                     => true,
      require                    => File["/etc/systemd/system/${jvm_name}.service"],
      subscribe                  => [
        Class['jboss7::filemanager'],
        ],
        }
        }
        }
        }
