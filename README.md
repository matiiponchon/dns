# BIND 9
Versatile, classic, complete name server software.

## Why use BIND 9?
BIND 9 has evolved to be a very flexible, full-featured DNS system. Whatever your application is, BIND 9 probably has the required features. As the first, oldest, and most commonly deployed solution, there are more network engineers who are already familiar with BIND 9 than with any other system.

BIND 9 is transparent open source, licensed under the MPL 2.0 license.

## Requirements
* docker
* docker-compose

## Build

### Using docker-compose

To build BIND9 container using `docker-compose` enter the following:
```
git clone git@github.com:matiiponchon/dns.git
cd dns/
docker-compose build
```

### Using docker

To build BIND9 container using `docker` enter the following:
```
git clone git@github.com:matiiponchon/dns.git
cd dns/
docker build . -t matiiponchon/dns
```

## Start DNS server

### Using docker-compose
```
docker-compose up -d
```

### Using docker
```
docker run \
  --name 'dns'
  -v $PWD/externals:/etc/bind/externals \
  -p 53:53 \
  -d matiiponchon/dns
```

## Test DNS server

Get DNS IP:
```
IP=$(docker inspect dns | grep '"IPAddress"' | cut -d'"' -f4)
echo ${IP}
```

Test your root domain:
```
nslookup example.com - ${IP}
```

Test an A record:
```
nslookup ns.example.com - ${IP}
```

Test an A record from the Reverse zone:
```
nslookup 192.168.1.10 - ${IP}
```

# Configuration

* TBC

# Troubleshooting

## dig

You can test your setup using the DNS lookup utility dig:
```
docker exec dns dig -x 127.0.0.1
```
You should see lines similar to the following in the command output:
```
;; Query time: 1 msec
;; SERVER: 192.168.1.10#53(192.168.1.10)
```

## named-checkzone

This utility allows you to make sure the configuration is correct before restarting BIND9 and making the changes live.

To test our example Forward zone file enter the following from a command prompt:
```
docker exec dns named-checkzone example.com /etc/bind/externals/db.example.com
```
If everything is configured correctly you should see output similar to:
```
zone example.com/IN: loaded serial 3
OK
```
Similarly, to test the Reverse zone file enter the following:
```
docker exec dns named-checkzone 1.168.192.in-addr.arpa /etc/bind/externals/db.192
```
The output should be similar to:
```
zone 1.168.192.in-addr.arpa/IN: loaded serial 2
OK
```
The Serial Number of your zone file will probably be different.

## Logging

BIND9 is configured to send debug messages related to DNS queries to a separate file.

The debug option can be set from `1` to `3`. If a level isn't specified level `1` is the default. Currently debug option was set to `3` in `externals/externals.conf`.

### Using docker-compose

To check BIND9 logs enter the following:
```
docker-compose logs
```

### Using docker

To check BIND9 logs enter the following:
```
docker logs dns
```

### Using docker exec command

To check BIND9 service logs enter the following:
```
docker exec dns cat /var/log/syslog
```
