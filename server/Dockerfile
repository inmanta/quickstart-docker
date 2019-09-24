FROM centos:7
ENV container docker

COPY inmanta_oss_stable.repo /etc/yum.repos.d/inmanta_oss_stable.repo

RUN yum install -y epel-release
RUN yum install -y python3-inmanta python3-inmanta-server python3-inmanta-agent postgresql
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN mkdir /home/inmanta

RUN rm /etc/inmanta/inmanta.cfg
COPY server.cfg /etc/inmanta/inmanta.cfg
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

EXPOSE 8888
CMD until PGPASSWORD="inmanta" psql -h "postgres" -U "inmanta" -c '\q'; do sleep 1; done && /usr/bin/inmanta -vvv server
