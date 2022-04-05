class jboss7::java (
#$archive_directory 
$java_home,
$java_base,
$java_version,
$jboss_user,
) {
$archive_directory   = '/opt/pkgs/jboss'
#$archive_directory
##$java_home           = '/opt/jboss/eap7/java'
##$java_version    = '1.8.0_221'
##$java_base       = "jdk${java_version}"
$archive_javapkg = 'jdk-8u221-linux-x64.tar.gz'
#if $java_home.empty {
   exec { "Ensure java home is created ${java_home}":
     command    => "/bin/mkdir -p /opt/jboss/eap7/java",
     cwd        => '/opt',
     unless     => "/usr/bin/stat -c '%U' ${java_home} | /bin/grep -q ${jboss_user}"
   }
#   }
   
-> exec { "Install java on ${java_home}": 
#  command    => "/bin/unzip ${archive_directory}/{archive_javapkg} -d {java_home}",
  path       => '/bin',
  command    => "tar -zxvf ${archive_directory}/${archive_javapkg} -C ${java_home}",
  cwd        => "${archive_directory}",
  creates    => "${java_home}/${java_base}/bin/java",
  #require    => Exec["Ensure java home is created ${java_home}"],
  }  
}
