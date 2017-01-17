---
layout: index
---


##Corrección de @mmaguero

Comenzamos la correción probando Vagrant y Virtualbox.

Montamos la imagen y provisionamos con Chef-Solo









Para comprobar Vagrant y AWS debemos hacer lo siguiente:

Primero añadir las boxes de Vagrant correspondientes

* vagrant box add cloud https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

* vagrant box add solicitudes https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

Tras esto añadir nuestro grupo de seguridad al Vagrantfile.

Con todo esto, (no olvidar credenciales y claves de AWS) ya podemos probar la orquestación

`vagrant up --provider=aws`

![1](http://i1045.photobucket.com/albums/b460/Alejandro_Casado/2_zpsm0lmlu65.png)

![2](http://i1045.photobucket.com/albums/b460/Alejandro_Casado/1_zpsvvrz1ndv.png)

![3](http://i1045.photobucket.com/albums/b460/Alejandro_Casado/3_zpshijzhj9w.png)
