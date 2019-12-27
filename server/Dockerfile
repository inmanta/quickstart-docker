FROM centos:7
ENV container docker

ARG inmanta_repo="inmanta_oss_stable.repo"
COPY ${inmanta_repo} /etc/yum.repos.d/${INMANTA_REPO}

RUN yum install -y python3-inmanta python3-inmanta-server postgresql
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN mkdir /home/inmanta
RUN mkdir /home/inmanta/.shared
RUN ssh-keygen -b 4096 -t rsa -f ~/.ssh/id_rsa -q -N ""
RUN /bin/cp -rf ~/.ssh/id_rsa.pub /home/inmanta/.shared/authorized_keys
RUN chmod 600 /home/inmanta/.shared/authorized_keys

RUN rm /etc/inmanta/inmanta.cfg
COPY server.cfg /etc/inmanta/inmanta.cfg

EXPOSE 8888
CMD until PGPASSWORD="inmanta" psql -h "postgres" -U "inmanta" -c '\q'; do sleep 1; done && /usr/bin/inmanta -vvv server
