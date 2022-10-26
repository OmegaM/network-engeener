# Урок 5. Третий уровень модели TCP/IP. IP Адрес. Маска подсети

### 1 

```sql
192.168.50.107/27
-----------------
IP(DEC)      192.168.50.107
MASK(DEC)    255.255.255.224

IP(BIN)      11000000.10101000.00110010.01101011
MASK(BIN)    11111111.11111111.11111111.11100000

RES(BIN)     11000000.10101000.00110010.01100000
RES(DEC)     192.168.50.96

MIN          192.168.50.97
MAX          192.168.50.126

10.0.0.2/30
---------------
IP(DEC)      10.0.0.2
MASK(DEC)    255.255.255.252

IP(BIN)      00001010.00000000.00000000.00000010
MASK(BIN)    11111111.11111111.11111111.11111100

RES(BIN)     00001010.00000000.00000000.00000000
RES(DEC)     10.0.0.0

MIN          10.0.0.1
MAX          10.0.0.2

77.28.46.77/31
----------------
IP(DEC)       77.28.46.77
MASK(DEC)     255.255.255.254

IP(BIN)       01001010.00011100.00101110.01001101
MASK(BIN)     11111111.11111111.11111111.11111110

RES(BIN)      01001010.00011100.00101110.01001100
RES(DEC)      74.28.46.76

MIN           74.26.46.76
MAX           74.26.46.77

5.144.135.2/9
-----------------
IP(DEC)       5.144.135.2
MASK(DEC)     255.128.0.0

IP(BIN)       00000101.10010000.10000111.00000010
MASK(BIN)     11111111.10000000.00000000.00000000

RES(BIN)      00000101.10000000.00000000.00000000
RES(DEC)      5.128.0.0

MIN           5.128.0.1
MAX           5.255.255.254

````

### 2

```bash
Router(config-if)#ip address 10.0.0.3 255.255.255.0
% 10.0.0.0 overlaps with FastEthernet0/0
Router(config-if)#do show run
....
interface FastEthernet0/0
 ip address 10.0.0.2 255.255.255.0
 duplex auto
 speed auto
!
interface FastEthernet0/1
 ip address 10.0.0.3 255.255.255.0
 duplex auto
 speed auto
 shutdown
....
Router(config-if)# no shutdown
% 10.0.0.0 overlaps with FastEthernet0/0
FastEthernet0/1: incorrect IP address assignment
```