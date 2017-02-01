---
layout: index
---
# MyStudentBot

## Introducción

@My_Student_Bot

Este proyecto consiste en el despliegue de un bot de telegram realizado utilizando [pyTelegramBotAPI](https://github.com/eternnoir/pyTelegramBotAPI) una api para realizar bots en telegram .

El objetivo de este bot es apoyar al estudiante universitario ayudándole con sus clases, tareas a realizar..etc. Uno de los puntos fuertes que busca este proyecto es que la interación entre el bot y el usuario se realice de la manera mas natural posible, evitando tener que realizar mensajes esquemáticos por parte del usuario, lo que puede dar lugar a errores.


## Tecnología

### Arquitectura

Para la arquitectura se ha elegido una basada en microservicios. Estos microservicios son independientes entre ellos y pueden ser desarrollados, desplegados y testeados de manera indiviual.

La idea es que el bot funcionará como API, atendiendo al esquema general de microservicios, y hará uso de los distintos microservicios implementados según las peticiones del usuario. Básicamente el usuario le hablará al bot y este dependiendo de lo que haya escrito el usuario utilizará un microservicio u otro.


### Microservicios

Como comienzo el bot contará con tres microservicios:

Nota: Los microservicios se encuentran en su versión mas básica, sus funcionalidades irán aumentando a lo largo del desarrollo de la asignatura.

#### Gestión académica

Este microservicio apoyará al usuario almacenando información sobre asignaturas, clases, aulas, horarios... El usuario introducirá la información comentada y se le enviará una serie de avisos del estilo de: "Tienes clase de CC en el aula 1.6 en 30 minutos". Por otro lado existirá la posibilidad de la creación de un horario partiendo de la información aportada. En este caso se usará una base de datos sql.

#### Gestión de tareas.

La idea de este microservicio es que sea lo mas flexible posible, es decir, el usuario le escribiría al bot "Hacer hito 1 de CC para el 10/10/2100" el único formato que debe respetar el usuario es el de la fecha, por lo demás puede escribir lo que desee. También contará con una serie de avisos configurables para recordar las tareas a realizar y evitar que estas no se entreguen. Este microservicio contará con una base de datos mongoDB


#### Gestión de gastos.

Como es natural, un estudiante universitario tiene muchos gastos. El objetivo de este microservicio es llevar un registro de lo gastado por el usuario a lo largo de un periodo de tiempo, 1 mes por ejemplo, y representar dichos gastos utilizando una serie de gráficos a elección del usuario. También será posible comparar los gastos con los de los meses anteriores. El usuario escribiría al bot diciendo: "Bus 5€ semana", el bot se pondría en contacto con este microservicio y los datos quedarían almacenados. Este microservicio tambíen se encarga de la creación de los gráficos comentandos anteriormente y de su envio al bot cuando este lo precise.


## Provisionamiento

### Puppet

Se trata de un gestor de configuraciones escrito en ruby y ha sido elegido como gestor ya que se trata de unos de los principales y más [conocidos gestores de configuraciones](http://www.infoworld.com/article/2614204/data-center/puppet-or-chef--the-configuration-management-dilemma.html)

Lo primero que debemos hacer es generar un fichero .pp indicando en él todo lo que queremos instalar sobre la máquina.

~~~
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
~~~

Para que la contraseña se asocie correctamente con el usuario ha de generarse de la [siguiente manera](http://stackoverflow.com/questions/19114328/managing-a-user-password-for-linux-in-puppet):

~~~
openssl passwd -1
~~~


![](http://i64.tinypic.com/ou781v.png)

El resultado de la ejecución del comando anterior ha de ser copiado en el parámetro `password` del fichero .pp

Una vez hecho esto lo siguiente que debemos hacer es conectarnos via ssh con nuestra máquina.

Dentro de nuestra máquina, actualizamos repositorios e instalamos puppet:

`sudo apt-get update`
 
`sudo apt-get install puppet`


Después, descargamos el fichero .pp de este repositorio:

`curl https://raw.githubusercontent.com/acasadoquijada/MyStudentBot/master/provision/puppet/default.pp > default.pp`


Finalmente ejecutamos el fichero para aprovisionar la máquina:

`sudo puppet apply default.pp`


![2](http://i68.tinypic.com/2r6jy9u.png)

En este caso podemos ver como se ha creado correctamente el usuario y como se han instalado pip y pyTelegramBotAPI

### Ansible

He decidido utilizar ansible ya que se necesita python para su ejecución y viene instalado por defecto en la mayoría de los sistemas operativos

Lo primero que debemos hacer es instalar ansible

`sudo apt-get install ansible`

Como en el caso anterior nos debemos crear un fichero con los paquetes a instalar e instrucciones a ejecutar.

En este caso se llama `playbook.yml`

~~~
- hosts: all
  sudo: true
  tasks:
    - name: Actualizamos
      apt: update_cache=yes
    - name: Instalar pip
      apt: name=python-setuptools state=present
      apt: name=python-dev state=present 
      apt: name=python-pip state=present
    - name: Instalamos supervisor
      apt: name=supervisor state=present
    - name: Instalamos pyTelegramBotAPI
      pip: name=pyTelegramBotAPI
      #http://docs.ansible.com/ansible/faq.html#how-do-i-generate-crypted-passwords-for-the-user-module
      #Contraseña es hola
    - name: Creamos usuario con contraseña y acceso sudo
      user: name=user shell=/bin/bash group=admin password=$6$8K/WYk4Ajov$j84F1tY4SSY0T46HEVw14lYgkaQKeXyIS/X0mtvBMVkxD5SRtcVuwGJ2Lbot2nh5DK/ZMsxrajHJANo1j.uc6.
~~~

Para generar correctamente la contraseña ejecutamos

`mkpasswd --method=sha-512`

Y copiamos su salida en el campo `password` de `user:`

Por otro lado hay que crear un fichero `ansible_hosts` con lo siguiente:

~~~
[aws]
ip de la maquina ansible_ssh_user='ubuntu'
~~~

El último paso que debemos hacer antes de provisionar la máquina es generar la pareja de claves

`aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem`

Una vez realizados todos los preparativos procedemos a provisionar la máquina:

`sudo ansible-playbook -i ansible_hosts --private-key parclave.pem -b playbook.yml`

![3](http://i63.tinypic.com/9um2ol.png)


## Orquestación

Para realizar la orquestación de las máquinas en aws vamos a utilizar [Vagrant](https://www.vagrantup.com/)

Lo primero que debemos hacer es crear un fichero Vagrantfile. En mi caso es el siguiente:

~~~
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.


   config.vm.define "maquina_ansible" do |maquina_ansible|
      maquina_ansible.vm.box = "aws"
        maquina_ansible.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV['AWS_KEY']
        aws.secret_access_key = ENV['AWS_SECRET']
        aws.keypair_name = ENV['AWS_KEYNAME']

        
        aws.tags = {
		    'Name' => 'Vagrant con ansible',
		    'Environment' => 'vagrant-sandbox'
        } 
        
        aws.region = "us-east-1"
        aws.ami = "ami-1081b807"
        aws.instance_type = "t2.micro"
        aws.security_groups = ["vagrant"]
        
        override.ssh.username = "ubuntu"  #ec2-user
        override.ssh.private_key_path = ENV['AWS_KEYPATH']
      end
        
      maquina_ansible.vm.provision :ansible do |ansible|
        ansible.playbook = "playbook.yml"
      end
   end

   config.vm.define "maquina_chef" do |maquina_chef|
      maquina_chef.vm.box = "aws"
        maquina_chef.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV['AWS_KEY']
        aws.secret_access_key = ENV['AWS_SECRET']
        aws.keypair_name = ENV['AWS_KEYNAME']

        
        aws.tags = {
		    'Name' => 'Vagrant con chef',
		    'Environment' => 'vagrant-sandbox'
        } 
        
        aws.region = "us-east-1"
        aws.ami = "ami-1081b807"
        aws.instance_type = "t2.micro"
        aws.security_groups = ["vagrant"]
        
        override.ssh.username = "ubuntu"  #ec2-user
        override.ssh.private_key_path = ENV['AWS_KEYPATH']
      end
        
      maquina_chef.vm.provision "chef_solo" do |chef|
        chef.add_recipe "mystudentbot"
      end
   end


end
~~~

En este fichero de configuración de Vagrant creamos y provisionamos dos máquinas, una de ellas ha sido provisionada con el script de ansible creado anteriormente y la otra utilizando chef.

Ahora vamos a explicar como levantar las máquinas y provisionarlas.

Basta con ejecutar `vagrant up --provider=aws` para que comience el proceso


![imagen](http://i68.tinypic.com/2u53wpv.png)

![imagen2](http://i64.tinypic.com/fblrft.png)

Una vez hecho esto, ya dispondremos de nuestra máquinas listas en aws

![imagen3](http://i66.tinypic.com/1z3nwcm.png)



## Contenedores

Como gestor de contenedores he utilizado [docker](https://www.docker.com/) debido a su comunidad y a su facilidad de uso.

Ahora vamos a explicar como generar un contenedor con una imagen, instalando en ella lo necesario y subir dicha imagen a Docker Hub para que otros usuarios puedan utilizarla.

Para generar nuestro contenedor en dockerhub lo primero que debemos de hacer es de colocar un fichero [Dockerfile](https://github.com/acasadoquijada/MyStudentBot/blob/master/Dockerfile) con todo lo necesario en la raíz de la rama master de nuestro repositorio.

Una vez hecho esto hay que registrarse en dicha web y añadir nuestro repositorio. Con esto, deberá comenzar la creación de nuestro contenedor en Docker Hub.

Cuando este generado, todo el mundo podra descargarlo en su equipo para probarlo. El enlace de mi contenedor puede ser consultado [aquí](https://hub.docker.com/r/acasadoquijada/mystudentbot/)

Para descargar mi contenedor debemos usar:

`docker pull acasadoquijada/mystudentbot`

Y para conectar:

`sudo docker run -t -i acasadoquijada/mystudentbot`

## Despliegue

Este proyecto cuenta de 3 microservicios, aunque 2 de ellos (gestión de tareas y gestión academica) pueden unificarse en 1 ,a parte del propio bot, que puede considerarse como otro.

Una vez explicado lo anterior, vamos a prodecer a explicar el despliegue:

### Gestión académica y de tareas.

Este microservicio necesita una base de datos MongoDB, aunque gestión académica utilizaba en un principio una BD sql .La elegida ha sido [mLab](https://mlab.com/).

Nos ofrece un plan gratuito de hasta 500 MB de capacidad, lo que es más que suficiente para este microservicio.

Una vez registrados, debemos configurar nuestra BD y obtendremos la siguiente información:

![mongo](http://i1045.photobucket.com/albums/b460/Alejandro_Casado/mlab_zpsmtgq085o.png)

Para utilizarla, debemos instalar la libreria [mlab](https://pypi.python.org/pypi/mlab) en python.

El provisionamiento para este microservicio debe ser modificado para añadir dicha libreria.

### Gestión de gastos.

Volvemos a necesitar una base de datos MongoDB, por lo que debemos repetir los pasos anteriores.

También hemos de modificar el provisionamiento para poder generar los distintos gráficos. Para generarlos se va a usar la librería [ploty](https://pypi.python.org/pypi/plotly) ya que dispone de una gran cantidad de tutoriales y comunidad apoyandala, también es muy fácil de usar.

### Bot.

Este microservicio es el que interacciona con el usuario, por lo que es natural pensar que debe disponer de un servicio de log. Para mayor fiabilidad mejor praxis, vamos a utilizar un servicio externo para tal necesidad.

Hay gran cantidad de servicios de log como [logz.io](http://logz.io/) o [papertrail](https://papertrailapp.com/). Nos hemos decantado por este último.

Su funcionamiento es muy sencillo, basta con registrarse, seleccionar el sistema que estamos usando y [configurar nuestra aplicación](http://help.papertrailapp.com/kb/configuration/configuring-centralized-logging-from-python-apps/)

![log](http://i64.tinypic.com/29auuqf.png)

Las librerias necesarias para el uso del sistema de log, `logging` y `socket`, vienen instaladas por defecto en python, por lo que no es necesario instalarlas

Para cada uno de dichos servicios se ha creado su correspondiente contenedor docker:

* [Contenedor bot](https://hub.docker.com/r/acasadoquijada/mystudentbot/). El realizado en prácticas anteriores
* [Contenedor académico-tareas](https://hub.docker.com/r/acasadoquijada/mystudentbot-academico-gestion/)
* [Contenedor gastos](https://hub.docker.com/r/acasadoquijada/mystudentbot-gastos/)

Estos contenedores son los que se desplegarán en AWS utilizando Vagrant.

Nota: Mucho cuidado con las claves de AWS, es VITAL usarlas bien para evitar problemas.

Ahora que sabemos el funcionamiento de los distintos microservicios y sus contenedores asociados generamos los [playbook necesarios](https://github.com/acasadoquijada/MyStudentBot/tree/master/despliegue/Playbooks) y el correspondiente [Vagrantfile](https://github.com/acasadoquijada/MyStudentBot/blob/master/despliegue/Vagrantfile).

Finalmente usamos `vagrant up --provider=aws` para desplegar todas las máquinas.

### Licencia

La licencia usada en el proyecto es [GNU GLP V3](https://github.com/acasadoquijada/MyStudentBot/blob/master/LICENSE)







