FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y bind9
RUN apt-get install -y rsyslog
RUN apt-get install -y dnsutils

RUN echo 'include "/etc/bind/externals/externals.conf";' >> /etc/bind/named.conf.local
RUN sed 's|listen-on-v6 { any; };|\0\n\tallow-transfer {"none";};|g' -i /etc/bind/named.conf.options

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
