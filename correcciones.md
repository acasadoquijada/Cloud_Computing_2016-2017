---
layout: index
---

## Provisionamiento usando ansible de @Gringer

La prueba de provisionamiento se ha realizado sobre una máquina Ubuntu 14 en AWS.

Para realizar la comprobación de que el provisionamiento funciona correctamente se ha ejecutado la orden

`sudo ansible-playbook -i ansible_hosts --private-key parclave.pem -b playbook.yml`

Siendo `playbook.yml` el fichero [playbook.yml](https://github.com/Griger/CC/blob/master/provision/Ansible/playbook.yml) de mi compañero.

La ejecución de lo anterior produce la siguiente salida:

[](https://camo.githubusercontent.com/f6ba7f79a8a86dfb25f3563f929c06c117466787/687474703a2f2f6936382e74696e797069632e636f6d2f6f746b6861702e706e67)

En la cual se puede comprobar que el provisionamiento ha funcionado correctamente


