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

### Licencia

La licencia usada en el proyecto es [GNU GLP V3](https://github.com/acasadoquijada/MyStudentBot/blob/master/LICENSE)


