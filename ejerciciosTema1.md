---
layout: ejercicios
---

# Ejercicios arquitecturas software para la nube

## Ejercicio 1

### Buscar una aplicación de ejemplo, preferiblemente propia, y deducir qué patrón es el que usa. ¿Qué habría que hacer para evolucionar a un patrón tipo microservicios?

La aplicación elegida ha sido [Bares](https://github.com/acasadoquijada/IV) realizada durante el curso anterior.

Utiliza el patrón modelo, vista, controlador (MVC).

Para evolucionar a un patrón tipo microservicios deberiamos modularizar los distintos componentes de la aplicación, transformarlos en microservicios, y utilizar api REST para la comunicación entre dichos componentes.

## Ejercicio 2

### En la aplicación que se ha usado como ejemplo en el ejercicio anterior, ¿podría usar diferentes lenguajes? ¿Qué almacenes de datos serían los más convenientes?

En la aplicación anterior solo se ha usado python, pero si la aplicación evolucionara a un patrón microservicios, cada microservicio podría ser implementando en un lenguaje diferente.

Para facilitar la comunicación entre los distintos microservicios, una buena opción sería utilizar mongodb, ya que almacena los datos en formato JSON. Por otro lado, si usásemos algo del tipo sql, habría que realizar una serie de transformaciones cada vez que queramos realizar comunicaciones.
