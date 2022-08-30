# Урок 2. Взаимодействие с оболочкой bash

### 1. 
#### a.
```bash
[centos@fhmkq721al0lgjkh7lgh /]$ cd /home/centos/
[centos@fhmkq721al0lgjkh7lgh ~]$ pwd
/home/centos
```
#### b.
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ ls -la
total 16
drwx------. 3 centos centos  95 Aug 30 12:59 .
drwxr-xr-x. 3 root   root    20 Aug 30 12:41 ..
-rw-------. 1 centos centos   8 Aug 30 12:59 .bash_history
-rw-r--r--. 1 centos centos  18 Nov 24  2021 .bash_logout
-rw-r--r--. 1 centos centos 193 Nov 24  2021 .bash_profile
-rw-r--r--. 1 centos centos 231 Nov 24  2021 .bashrc
drwx------. 2 centos centos  29 Aug 30 12:41 .ssh
```

#### c.
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ ls -laR
.:
total 16
drwx------. 3 centos centos  95 Aug 30 12:59 .
drwxr-xr-x. 3 root   root    20 Aug 30 12:41 ..
-rw-------. 1 centos centos   8 Aug 30 12:59 .bash_history
-rw-r--r--. 1 centos centos  18 Nov 24  2021 .bash_logout
-rw-r--r--. 1 centos centos 193 Nov 24  2021 .bash_profile
-rw-r--r--. 1 centos centos 231 Nov 24  2021 .bashrc
drwx------. 2 centos centos  29 Aug 30 12:41 .ssh

./.ssh:
total 4
drwx------. 2 centos centos  29 Aug 30 12:41 .
drwx------. 3 centos centos  95 Aug 30 12:59 ..
-rw-------. 1 centos centos 587 Aug 30 12:41 authorized_keys
```

### 2.
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ touch file{1..20} && mkdir dir && mv file* dir/
[centos@fhmkq721al0lgjkh7lgh ~]$ ls -la dir/
total 0
drwxrwxr-x. 2 centos centos 277 Aug 30 14:03 .
drwx------. 4 centos centos 106 Aug 30 14:03 ..
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file1
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file10
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file11
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file12
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file13
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file14
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file15
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file16
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file17
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file18
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file19
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file2
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file20
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file3
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file4
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file5
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file6
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file7
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file8
-rw-rw-r--. 1 centos centos   0 Aug 30 14:03 file9
```
> не нашел /var/log/syslog, по этому забрал все что связанно с логами =) 
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ sudo cp /var/log/*log dir/
[centos@fhmkq721al0lgjkh7lgh ~]$ ls -la dir/*log
-rw-------. 1 root   root   123502 Aug 30 14:06 dir/cloud-init.log
-rw-r--r--. 1 centos centos 292292 Aug 30 14:06 dir/lastlog
-rw-------. 1 root   root      218 Aug 30 14:06 dir/maillog
-rw-------. 1 root   root    64064 Aug 30 14:06 dir/tallylog
-rw-------. 1 root   root     2371 Aug 30 14:06 dir/yum.log
```
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ sudo tar cvf result.tar dir/
dir/
dir/file1
dir/file10
dir/file11
dir/file12
dir/file13
dir/file14
dir/file15
dir/file16
dir/file17
dir/file18
dir/file19
dir/file2
dir/file20
dir/file3
dir/file4
dir/file5
dir/file6
dir/file7
dir/file8
dir/file9
dir/lastlog
dir/cloud-init.log
dir/maillog
dir/tallylog
dir/yum.log
[centos@fhmkq721al0lgjkh7lgh ~]$ ll
total 496
drwxrwxr-x. 2 centos centos   4096 Aug 30 14:06 dir
-rw-rw-r--. 1 centos centos 501760 Aug 30 14:09 result.tar
```
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ rm -rf result.tar
[centos@fhmkq721al0lgjkh7lgh ~]$ ls -la
total 20
drwx------. 4 centos centos  106 Aug 30 14:09 .
drwxr-xr-x. 3 root   root     20 Aug 30 12:41 ..
-rw-------. 1 centos centos    8 Aug 30 12:59 .bash_history
-rw-r--r--. 1 centos centos   18 Nov 24  2021 .bash_logout
-rw-r--r--. 1 centos centos  193 Nov 24  2021 .bash_profile
-rw-r--r--. 1 centos centos  231 Nov 24  2021 .bashrc
drwx------. 2 centos centos   29 Aug 30 12:41 .ssh
drwxrwxr-x. 2 centos centos 4096 Aug 30 14:06 dir
```
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ history
    1  sudo su
    2  clear
    3  ls -la /home/
    4  clear
    5  cd /
    6  cd /home/centos/
    7  pwd
    8  ls -la
    9  ls -laR
   10  touch file{1..20} && mkdir dir && mv file* dir/
   11  ls -la dir/
   12  find /** -name syslog
   13  find /** -name syslog 2> /dev/null
   14  ls -la /var/log
   15  cat /var/log/lastlog
   16  cat /var/log/messages
   17  cp /var/log/*log dir/
   18  sudo cp /var/log/*log dir/
   19  ls -la dir/*log
   20  tar cvf result.tar dir/
   21  sudo tar cvf result.tar dir/
   22  ll
   23  rm -rf result.tar
   24  ls -la
   25  history
```
### 3.
> YAML файлов не нашел ни по *.yaml ни по *.yml, взял файлы .conf
```bash
sudo find /etc -iname "*.conf" -type f 2> /dev/null
/etc/resolv.conf
...
/etc/rsyslog.conf
/etc/rsyncd.conf
/etc/man_db.conf
/etc/sudo-ldap.conf
/etc/sudo.conf
/etc/vconsole.conf
/etc/locale.conf
```
### 4.
```bash
[centos@fhmkq721al0lgjkh7lgh ~]$ mkdir -p {2015..2021}/{1..12}
[centos@fhmkq721al0lgjkh7lgh ~]$ tree
.
|-- 2015
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2016
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2017
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2018
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2019
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2020
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
|-- 2021
|   |-- 1
|   |-- 10
|   |-- 11
|   |-- 12
|   |-- 2
|   |-- 3
|   |-- 4
|   |-- 5
|   |-- 6
|   |-- 7
|   |-- 8
|   `-- 9
```