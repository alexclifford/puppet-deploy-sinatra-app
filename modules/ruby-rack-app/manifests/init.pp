class ruby-rack-app {

exec {
	"os-security-updates":
		command => "/usr/bin/apt-get update; /usr/bin/apt-get upgrade -y",
		logoutput => true
}

package { 'git': ensure => "installed", require => Exec['os-security-updates'] }
package { 'ruby-bundler': ensure => "installed", require => Package['git'] }
package { 'rubygems': ensure => "installed", require => Package['ruby-bundler'] }
package { 'libapache2-mod-passenger': ensure => "installed", require => Package['rubygems'] }
package { 'sinatra': ensure => "installed", provider => "gem", require => Package['libapache2-mod-passenger'], notify  => Notify['reload-apache2'] }

exec {
	"clone_sinatra_app":
		command => "/usr/bin/git clone git://github.com/tnh/simple-sinatra-app.git /var/www/sinatra_app",
		cwd => "/var/www/",
		creates => "/var/www/sinatra_app",
		notify  => Notify['reload-apache2'],
		logoutput => true,
		require => Package['sinatra']
}

file {
        'sinatra_app.conf':
                path => "/etc/apache2/conf.d/sinatra_app.conf",
                ensure => file,
		notify  => Notify['reload-apache2'],
                require => Exec['clone_sinatra_app'],
                source => "puppet:///modules/ruby-rack-app/sinatra_app.conf"
}

service { "apache2":
	ensure  => "running",
	enable  => "true",
	require => Package['libapache2-mod-passenger'],
}

notify { "reload-apache2":
	notify => Service['apache2']
}

}
