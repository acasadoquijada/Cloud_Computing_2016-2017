#Creamos un nuevo usuario

user { 'usuario':
  ensure  => 'present',
  password => '$1$aJpM0z8S$g3hapJjj3yePnS8gRHYQ1/', #Generamos la clave con openssl y copiamos el resultado
  comment => 'Comentario',
  gid     => '100',
  groups  => ['sudo', 'audio', 'src', 'video'],
  home    => '/home/usuario',
  shell   => '/bin/bash',
  uid     => '1002',
  managehome => yes,
}

#Instalamos pip

package{ 'python-pip':
  ensure => 'present',
}

#Instalamos pyTelegramBotAPI
package { ['pyTelegramBotAPI==2.2.3']:

  ensure => present,

  provider => pip,

  require => Package['python-pip'],

}

#Instalamos supervisor

package{ 'supervisor':
  ensure=>'present',
}

