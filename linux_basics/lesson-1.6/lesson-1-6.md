# Урок 6. Процессы. Systemd и его возможности
### 1.
```bash 
[root@fhmtd7l02cvu4aq9hftn centos]# cat /etc/ssh/sshd_config | grep PasswordAuthentication
#PasswordAuthentication yes
PasswordAuthentication no
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication, then enable this but set PasswordAuthentication

[root@fhmtd7l02cvu4aq9hftn centos]# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2022-09-10 11:50:41 UTC; 8s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1255 (sshd)
   CGroup: /system.slice/sshd.service
           ├─1215 sshd: [accepted]
           ├─1217 sshd: [accepted]
           ├─1220 sshd: [accepted]
           ├─1221 sshd: [accepted]
           ├─1225 sshd: [accepted]
           ├─1227 sshd: [accepted]
           ├─1228 sshd: [accepted]
           ├─1229 sshd: [accepted]
           ├─1232 sshd: [accepted]
           ├─1233 sshd: [accepted]
           └─1255 /usr/sbin/sshd -D

[root@fhmtd7l02cvu4aq9hftn centos]# cat /etc/ssh/sshd_config | grep PasswordAuthentication
#PasswordAuthentication yes
PasswordAuthentication yes
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication, then enable this but set PasswordAuthentication
[root@fhmtd7l02cvu4aq9hftn centos]# systemctl reload sshd
[root@fhmtd7l02cvu4aq9hftn centos]# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2022-09-10 11:50:41 UTC; 1min 16s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 1265 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 1255 (sshd)
   CGroup: /system.slice/sshd.service
           ├─1215 sshd: [accepted]
           ├─1217 sshd: [accepted]
           ├─1220 sshd: [accepted]
           ├─1221 sshd: [accepted]
           ├─1225 sshd: [accepted]
           ├─1227 sshd: [accepted]
           ├─1228 sshd: [accepted]
           ├─1229 sshd: [accepted]
           ├─1232 sshd: [accepted]
           ├─1233 sshd: [accepted]
           └─1255 /usr/sbin/sshd -D

[root@fhmtd7l02cvu4aq9hftn centos]# cat /etc/ssh/sshd_config | grep PasswordAuthentication
#PasswordAuthentication yes
PasswordAuthentication no
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication, then enable this but set PasswordAuthentication

[root@fhmtd7l02cvu4aq9hftn centos]# systemctl restart sshd
[root@fhmtd7l02cvu4aq9hftn centos]# systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sat 2022-09-10 11:53:39 UTC; 6s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 1265 ExecReload=/bin/kill -HUP $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 1278 (sshd)
   CGroup: /system.slice/sshd.service
           └─1278 /usr/sbin/sshd -D

Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal systemd[1]: Stopping OpenSSH server daemon...
Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal systemd[1]: Stopped OpenSSH server daemon.
Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal systemd[1]: Starting OpenSSH server daemon...
Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal sshd[1278]: Server listening on 0.0.0.0 port 22.
Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal sshd[1278]: Server listening on :: port 22.
Sep 10 11:53:39 fhmtd7l02cvu4aq9hftn.auto.internal systemd[1]: Started OpenSSH server daemon.
```
>>>
Systemctl restart - останавливает демона и запускает его заново.
Systemctl reload  - Заставляет сервис перечитать конфигурационный файл, без остановки процесса. Альтернатива - kill -1 main_procces_pid
>>>

### 2.
```bash
[root@fhmtd7l02cvu4aq9hftn centos]# who
centos   pts/0        Sep 10 11:47 (46-138-56-31.dynamic.spd-mgts.ru)
centos   pts/1        Sep 10 12:03 (46-138-56-31.dynamic.spd-mgts.ru)

[centos@fhmtd7l02cvu4aq9hftn ~]$ ps aux | grep mc
root      1381  0.1  0.5 164904  5584 pts/0    S+   12:04   0:00 mc
centos    1394  0.0  0.0 112784   752 pts/1    S+   12:04   0:00 grep --color=auto mc

[centos@fhmtd7l02cvu4aq9hftn ~]$ sudo kill -9 $(ps aux | grep mc | grep root | awk '{print $2}')
```
![mc_kill](../imgs/mc_kill.png)

### 3.
```bash
[root@fhmb587biqp0e19vhuhc centos]# cat /etc/systemd/system/geekbrains.service
[Unit]
Description=Service which ping localhost in several threads

[Service]
EnvironmentFile=/tmp/ping_env
ExecStart=/tmp/ping.py ${THREAD_COUNT} ${PACKAGES}
User=centos
Group=centos

[Install]
RequiredBy=network.target

[root@fhmb587biqp0e19vhuhc centos]# cat /tmp/ping_env
THREAD_COUNT=10
PACKAGES=300

[root@fhmb587biqp0e19vhuhc centos]# systemctl daemon-reload
[root@fhmb587biqp0e19vhuhc centos]# systemctl status geekbrains
● geekbrains.service - Service which ping localhost in several threads
   Loaded: loaded (/etc/systemd/system/geekbrains.service; disabled; vendor preset: disabled)
   Active: inactive (dead)

Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: PING localhost (127.0.0.1) 56(84) bytes of data.
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.011 ms
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: PING localhost (127.0.0.1) 56(84) bytes of data.
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.011 ms
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: PING localhost (127.0.0.1) 56(84) bytes of data.
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.013 ms
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: PING localhost (127.0.0.1) 56(84) bytes of data.
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.011 ms
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: PING localhost (127.0.0.1) 56(84) bytes of data.
Sep 10 19:13:00 fhmb587biqp0e19vhuhc.auto.internal ping.py[1532]: 64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.073 ms

[root@fhmb587biqp0e19vhuhc centos]# systemctl enable geekbrains
Created symlink from /etc/systemd/system/network.target.requires/geekbrains.service to /etc/systemd/system/geekbrains.service.

[root@fhmb587biqp0e19vhuhc centos]# systemctl restart  geekbrains && \
                                    echo "Before kill" && \
                                    ps aux | grep ping  && \
                                    kill -9 $(ps aux | grep ping| head -n 1 | awk '{print $2}') && \
                                    echo "After kill" && ps aux | grep ping
Before kill
centos    1910  0.0  0.4 124560  4660 ?        Rs   19:26   0:00 /usr/bin/python3 /tmp/ping.py 10 300
root      1912  0.0  0.0 112784   752 pts/1    S+   19:26   0:00 grep --color=auto ping
After kill
root      1919  0.0  0.0 112784   752 pts/1    R+   19:26   0:00 grep --color=auto ping

[root@fhmb587biqp0e19vhuhc centos]# systemctl status geekbrains
● geekbrains.service - Service which ping localhost in several threads
   Loaded: loaded (/etc/systemd/system/geekbrains.service; enabled; vendor preset: disabled)
   Active: failed (Result: signal) since Sat 2022-09-10 19:26:57 UTC; 2min 30s ago
  Process: 1910 ExecStart=/tmp/ping.py ${THREAD_COUNT} ${PACKAGES} (code=killed, signal=KILL)
 Main PID: 1910 (code=killed, signal=KILL)

Sep 10 19:26:57 fhmb587biqp0e19vhuhc.auto.internal systemd[1]: Started Service which ping localhost in several threads.
Sep 10 19:26:57 fhmb587biqp0e19vhuhc.auto.internal systemd[1]: geekbrains.service: main process exited, code=killed, status=9/KILL
Sep 10 19:26:57 fhmb587biqp0e19vhuhc.auto.internal systemd[1]: Unit geekbrains.service entered failed state.
Sep 10 19:26:57 fhmb587biqp0e19vhuhc.auto.internal systemd[1]: geekbrains.service failed.
```