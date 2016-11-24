---
layout: index
---

## Provisionamiento usando ansible de @Gringer

La prueba de provisionamiento se ha realizado sobre una máquina Ubuntu 14 en AWS.

Para realizar la comprobación de que el provisionamiento funciona correctamente se ha ejecutado la orden

`sudo ansible-playbook -i ansible_hosts --private-key parclave.pem -b playbook.yml`

Siendo `playbook.yml` el fichero [playbook.yml](https://github.com/Griger/CC/blob/master/provision/Ansible/playbook.yml) de mi compañero.

La ejecución de lo anterior produce la siguiente salida:

![](http://i68.tinypic.com/otkhap.png)

En la cual se puede comprobar que el provisionamiento ha funcionado correctamente


