FROM centos:7
ENV container docker

COPY inmanta_oss_stable.repo /etc/yum.repos.d/inmanta_oss_stable.repo

RUN yum install -y epel-release
RUN yum install -y python3-inmanta python3-inmanta-server python3-inmanta-agent postgresql
RUN mkdir /home/inmanta

RUN rm /etc/inmanta/inmanta.cfg
COPY server.cfg /etc/inmanta/server.cfg

EXPOSE 8888
CMD /usr/bin/inmanta -c /etc/inmanta/server.cfg -vvv server
