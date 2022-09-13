# Урок 7. Работа с сетью в Linux

### 1.
```bash
ubuntu@fhml5uvvke9846mtfadq:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:15:2f:bf:fa brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.11/24 brd 192.168.10.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:15ff:fe2f:bffa/64 scope link
       valid_lft forever preferred_lft forever

ubuntu@fhml5uvvke9846mtfadq:~$ resolvectl
Global
       LLMNR setting: no
MulticastDNS setting: no
  DNSOverTLS setting: no
      DNSSEC setting: no
    DNSSEC supported: no
          DNSSEC NTA: 10.in-addr.arpa
                      16.172.in-addr.arpa
                      168.192.in-addr.arpa
                      17.172.in-addr.arpa
                      18.172.in-addr.arpa
                      19.172.in-addr.arpa
                      20.172.in-addr.arpa
                      21.172.in-addr.arpa
                      22.172.in-addr.arpa
                      23.172.in-addr.arpa
                      24.172.in-addr.arpa
                      25.172.in-addr.arpa
                      26.172.in-addr.arpa
                      27.172.in-addr.arpa
                      28.172.in-addr.arpa
                      29.172.in-addr.arpa
                      30.172.in-addr.arpa
                      31.172.in-addr.arpa
                      corp
                      d.f.ip6.arpa
                      home
                      internal
                      intranet
                      lan
                      local
                      private
                      test

Link 2 (eth0)
      Current Scopes: DNS
DefaultRoute setting: yes
       LLMNR setting: yes
MulticastDNS setting: no
  DNSOverTLS setting: no
      DNSSEC setting: no
    DNSSEC supported: no
  Current DNS Server: 192.168.10.2
         DNS Servers: 192.168.10.2
          DNS Domain: auto.internal
                      ru-central1.internal

root@fhml5uvvke9846mtfadq:/home/ubuntu# cat /etc/netplan/01-netcfg.yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses:
        - 192.168.10.11/24
      routes:
        - to: 192.168.10.0/24
          via: 192.168.10.1
          metric: 100

root@fhml5uvvke9846mtfadq:/home/ubuntu# netplan try --timeout 10
Do you want to keep these settings?


Press ENTER before the timeout to accept the new configuration


Changes will revert in  9 seconds
Configuration accepted.

root@fhml5uvvke9846mtfadq:/home/ubuntu# ip route show
default via 192.168.10.1 dev eth0 proto dhcp src 192.168.10.11 metric 100
192.168.10.0/24 dev eth0 proto kernel scope link src 192.168.10.11
192.168.10.0/24 via 192.168.10.1 dev eth0 proto static metric 100
192.168.10.1 dev eth0 proto dhcp scope link src 192.168.10.11 metric 100
```
### 2.
```bash
root@fhml5uvvke9846mtfadq:/home/ubuntu# ping geekbrains.ru
PING geekbrains.ru (178.248.232.209) 56(84) bytes of data.
64 bytes from 178.248.232.209 (178.248.232.209): icmp_seq=1 ttl=59 time=4.73 ms
...
```
### 3.
```bash
root@fhml5uvvke9846mtfadq:/home/ubuntu# tcpdump -nn "icmp[0] == 8" and host geekbrains.ru
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
09:01:02.230894 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1389, length 64
09:01:03.232006 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1390, length 64
09:01:04.233810 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1391, length 64
09:01:05.235695 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1392, length 64
09:01:06.237648 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1393, length 64
09:01:07.239537 IP 192.168.10.11 > 178.248.232.209: ICMP echo request, id 1, seq 1394, length 64
```
>> ICMP types :
>>
>> 0 Echo Reply
>>
>> 3 Destination Unreachable
>>
>> 4 Source Quench
>>
>> 5 Redirect
>>
>> 8 Echo
>>
>> 11 Time Exceeded

### 4.
```bash
root@fhml5uvvke9846mtfadq:/home/ubuntu# nc -vw3 geekbrains.ru {22,53,80,443}
nc: connect to geekbrains.ru port 22 (tcp) timed out: Operation now in progress
nc: connect to geekbrains.ru port 53 (tcp) timed out: Operation now in progress
Connection to geekbrains.ru 80 port [tcp/http] succeeded!
Connection to geekbrains.ru 443 port [tcp/https] succeeded!
```