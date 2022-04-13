
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
https://hub.docker.com/repository/docker/korsh84/
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
```
vagrant@server1:~$ docker pull nginx
vagrant@server1:~$ docker image  ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    12766a6745ee   2 weeks ago   142MB
```
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

```bash
vagrant@server1:~$ mkdir virt03_nginx
# переносим содержимое html
vagrant@server1:~$ vi virt03_nginx/index.html
# запускаем с монтированием директории на хосте 
vagrant@server1:~$ docker run -it --rm -d -p 8080:80 --name web -v ~/virt03_nginx:/usr/share/nginx/html nginx
#после  проверки переносим в контейнер
vagrant@server1:~$ docker stop web
# запуск без --rm
vagrant@server1:~$ docker run -it -d -p 8080:80 --name web nginx
#копируем  в контенйнер
vagrant@server1:~$ docker cp ~/virt03_nginx/index.html web:/usr/share/nginx/html
# коммит в образ
vagrant@server1:~$ docker commit web
vagrant@server1:~$ docker stop web
vagrant@server1:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
<none>       <none>    e0c77fad0dc8   11 minutes ago   142MB
nginx        latest    12766a6745ee   2 weeks ago      142MB

#делаем нормальное имя
vagrant@server1:~$ docker image tag e0c77fad0dc8 korsh84/nginx:korsh_virt03-1
vagrant@server1:~$ docker push korsh84/nginx:korsh_virt03-1
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки
https://hub.docker.com/repository/docker/korsh84/nginx

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

**Ответ**  для такого набора скорее нужно комплексное решение . 
Несколько физических среверов, на котры будет реализован сценарий:
1. Отдельный физический сервер под хранение MongoDB с необходимой отказоустойчивостью
2. Для монолитного приложения скорее подойдет аппаратная виртуализация, для возможности оперативного обновления
3. Gitlab сервер - физический, работает с контейнерами (Docker Registry)
4. Стек для мониторинга + ELK  на конетейнерах , для быстрого внесения изменений в рахитектуру, и реконфигурации
5. Шина данных Kafka - если высоконагруженная, то физический сервер
6. Веб и мобильные в контейнерах для быстрого обновления

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;

vagrant@server1:~$ docker run -it --rm -d --name korsh_centos -v ~/data:/data centos


- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
```bash
vagrant@server1:~$ docker run -it --rm -d --name korsh_debian -v ~/data:/data debian
```
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
```bash
# не получилось выполнить команду типа docker exec -it korsh_centos echo "test" > /data/korsh_cent.txt - ошибка вида no such file
vagrant@server1:~$ docker exec -it korsh_centos touch /data/korsh_cent.txt
vagrant@server1:~$ docker exec -it korsh_centos vi /data/korsh_cent.txt
```
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
```bash 
vagrant@server1:~$ echo "Host message" > ~/data/korsh_host.txt
```
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
```bash
vagrant@server1:~$ docker exec -it korsh_debian ls /data
korsh_cent.txt  korsh_host.txt
vagrant@server1:~$ docker exec -it korsh_debian cat  /data/korsh_cent.txt /data/korsh_host.txt
Hello from CentOS !

Host message
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

**Ответ**

Была ошибка при установке ansible в образ 
```
 Cannot install ansible-core with a pre-existing ansible==2.9.24
          installation.

          Installing ansible-core with ansible-2.9 or older, or ansible-base-2.10
          currently installed with pip is known to cause problems. Please uninstall
          ansible and install the new version:

              pip uninstall ansible
              pip install ansible-core

          If you want to skip the conflict checks and manually resolve any issues
          afterwards, set the ANSIBLE_SKIP_CONFLICT_CHECK environment variable:

              ANSIBLE_SKIP_CONFLICT_CHECK=1 pip install ansible-core
```
вставил в Dockerfile строку вида
```docker
pip install ansible==2.9.24 && \
ANSIBLE_SKIP_CONFLICT_CHECK=1 pip install mitogen ansible-lint jmespath && \
pip install --upgrade pywinrm && \

$ DOCKER_BUILDKIT=0 docker build -t korsh84/ansible:virt03-z4 .
```
но в итоге при запуске 
```
$ docker run -it --rm --name korsh_p4  korsh84/ansible:virt03-z4
ansible-playbook [core 2.12.4]
...

vagrant@server1:~$ docker push korsh84/ansible:virt03-z4
```
https://hub.docker.com/repository/docker/korsh84/ansible


