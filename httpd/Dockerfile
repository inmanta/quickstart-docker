FROM centos:7
ENV container docker

RUN yum update -y --setopt=tsflags=nodocs
RUN yum install -y --setopt=tsflags=nodocs httpd mod_ssl mod_proxy mod_security git openssl nano
RUN yum clean all

RUN git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /tmp/owasp
RUN mkdir /etc/httpd/modsecurity.d/owasp-modsecurity-crs
RUN cp -r /tmp/owasp/rules /etc/httpd/modsecurity.d/owasp-modsecurity-crs/rules
RUN rm -rf /tmp/owasp

COPY ssl /etc/httpd/ssl
COPY inmanta.conf /etc/httpd/conf.d/inmanta.conf
COPY csr-setup.conf /etc/httpd/modsecurity.d/owasp-modsecurity-crs/crs-setup.conf
COPY RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf /etc/httpd/modsecurity.d/owasp-modsecurity-crs/rules/
COPY run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

EXPOSE 80
EXPOSE 443
CMD ["/run-httpd.sh"]
