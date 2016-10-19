---
layout: ejercicios
---

# Ejercicios arquitecturas software para la nube

## Ejercicio 1

### Buscar una aplicación de ejemplo, preferiblemente propia, y deducir qué patrón es el que usa. ¿Qué habría que hacer para evolucionar a un patrón tipo microservicios?

La aplicación elegida ha sido [Bares](https://github.com/acasadoquijada/IV) realizada durante el curso anterior.

Utiliza el patrón modelo, vista, controlador (MVC).

Para evolucionar a un patrón tipo microservicios deberiamos modularizar los distintos componentes de la aplicación, transformarlos en microservicios, y utilizar api REST para la comunicación entre dichos componentes.
