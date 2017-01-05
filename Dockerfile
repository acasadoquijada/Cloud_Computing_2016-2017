FROM ubuntu:14.04
MAINTAINER Alejandro Casado Quijada <acasadoquijada@gmail.com>

RUN sudo apt-get update
RUN sudo apt-get upgrade
RUN sudo apt-get install python-dev
RUN sudo apt-get install python-pip
RUN sudo apt-get install supervisor
RUN sudo pip install pyTelegramBotAPI

RUN useradd -ms /bin/bash usuario

USER usuario
WORKDIR /home/usuario
