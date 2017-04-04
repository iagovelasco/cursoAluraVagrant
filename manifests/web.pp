exec{ "apt-update":
	command => "/usr/bin/apt-get update"
}


package { ["openjdk-7-jre", "tomcat7", "mysql-server"]:
	ensure => installed,
	require => Exec["apt-update"]
}

service{ "mysql":
		ensure => running,
		enable => true,
		hasstatus => true,
		require => Package["mysql-server"]
	
}

exec{ "musicjungle":
	command => "mysqladmin -uroot create musicjungle",
	unless => "mysql -u root musicjungle",
	path => "/usr/bin",
	require => Service["mysql"]	
}

exec{"musicjungle":
	command => "mysql -uroot -e "GRANT ALL PRIVILEGES ON * TO 'musicjungle'@'%' IDENTIFIED BY '1234';" musicjungle",
	unless => "mysql -umusicjungle -p1234 musicjungle",
	path => "/usr/bin",
	require => Service["mysql"]
}

service{ "tomcat7":
   		ensure => running,
   		enable => true,
    	hasstatus => true,
    	hasrestart => true,
    	require => Package["tomcat7"]
 }

file{ "/var/lib/tomcat7/webapps/vraptor-musicjungle.war":
   	source => "/vagrant/manifests/vraptor-musicjungle.war",
   	owner => "tomcat7",
   	group => "tomcat7",
   	mode => 0644,
   	require => Package["tomcat7"],
   	notify => Service["tomcat7"]
}
